--------------------------------------------------------
--  File created - Monday-October-26-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger ATTRIBUTE_PROPERTY_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."ATTRIBUTE_PROPERTY_AD" 
   BEFORE DELETE
   ON ATTRIBUTE_PROPERTY
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Attribute_Property_Ad';
lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO attribute_property_h
                  ( property,
                    ATTRIBUTE,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :OLD.property,
                    :OLD.ATTRIBUTE,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    :OLD.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."ATTRIBUTE_PROPERTY_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger ATTRIBUTE_PROPERTY_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."ATTRIBUTE_PROPERTY_OI" 
   BEFORE INSERT
   ON ATTRIBUTE_PROPERTY
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Attribute_Property_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO attribute_property_h
                  ( property,
                    ATTRIBUTE,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.property,
                    :NEW.ATTRIBUTE,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."ATTRIBUTE_PROPERTY_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger ATTRIBUTE_PROPERTY_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."ATTRIBUTE_PROPERTY_OU" 
   BEFORE UPDATE
   ON ATTRIBUTE_PROPERTY
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Attribute_Property_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO attribute_property_h
                  ( property,
                    ATTRIBUTE,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.property,
                    :NEW.ATTRIBUTE,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."ATTRIBUTE_PROPERTY_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CHARACTERISTIC_ASSOCIATION_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."CHARACTERISTIC_ASSOCIATION_AD" 
   BEFORE DELETE
   ON CHARACTERISTIC_ASSOCIATION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Characteristic_Association_Ad';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO characteristic_association_h
                  ( characteristic_id,
                    association,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :OLD.characteristic,
                    :OLD.association,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    :OLD.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."CHARACTERISTIC_ASSOCIATION_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CHARACTERISTIC_ASSOCIATION_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."CHARACTERISTIC_ASSOCIATION_OI" 
   BEFORE INSERT
   ON CHARACTERISTIC_ASSOCIATION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Characteristic_Association_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO characteristic_association_h
                  ( characteristic_id,
                    association,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.characteristic,
                    :NEW.association,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."CHARACTERISTIC_ASSOCIATION_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger CHARACTERISTIC_ASSOCIATION_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."CHARACTERISTIC_ASSOCIATION_OU" 
   BEFORE UPDATE
   ON CHARACTERISTIC_ASSOCIATION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Characteristic_Association_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO characteristic_association_h
                  ( characteristic_id,
                    association,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.characteristic,
                    :NEW.association,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."CHARACTERISTIC_ASSOCIATION_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger EXEMPTION_AI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."EXEMPTION_AI" 
   AFTER INSERT
   ON EXEMPTION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lqErrors                      iapiType.Ref_Type;
   lsSource                      iapiType.Source_Type := 'EXEMPTION_AI';
BEGIN
   lnRetVal := iapiEmail.RegisterEmail( :NEW.part_no,
                                        NULL,
                                        NULL,
                                        NULL,
                                        'E',
                                        NULL,
                                        NULL,
                                        NULL,
                                        :NEW.part_exemption_no,
                                        lqErrors );

   IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."EXEMPTION_AI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger EXEMPTION_AU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."EXEMPTION_AU" 
   AFTER UPDATE
   ON EXEMPTION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lqErrors                      iapiType.Ref_Type;
lsSource                      iapiType.Source_Type := 'EXEMPTION_AU';
BEGIN
   lnRetVal := iapiEmail.RegisterEmail( :NEW.part_no,
                                        NULL,
                                        NULL,
                                        NULL,
                                        'C',
                                        NULL,
                                        NULL,
                                        NULL,
                                        :NEW.part_exemption_no,
                                        lqErrors );

   IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
            iapiGeneral.LogError( lsSource,
                                 '',
                                 iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."EXEMPTION_AU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger IT_DEBUG_TRG_BRI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."IT_DEBUG_TRG_BRI" 
before insert
ON INTERSPC.IT_DEBUG 
referencing new as new old as old
for each row
begin
  select it_debug_seq.nextval
  into   :new.dbg_seq_no
  from   dual;
  :new.dbg_timestamp := sysdate;
  :new.dbg_type := nvl(:new.dbg_type, 'DBG');
  :new.dbg_user := user;
end;
/
ALTER TRIGGER "INTERSPC"."IT_DEBUG_TRG_BRI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger IT_ERROR_BRI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."IT_ERROR_BRI" 
BEFORE INSERT
ON ITERROR 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
  add_debug
    (p_table => 'ITERROR'
    ,p_message => :new.error_msg);
END;
/
ALTER TRIGGER "INTERSPC"."IT_ERROR_BRI" DISABLE;
--------------------------------------------------------
--  DDL for Trigger ITKWAS_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."ITKWAS_AD" 
   BEFORE DELETE
   ON ITKWAS
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'ITKWAS_OD',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO ITKWAS_h
                  ( kw_id,
                    ch_id,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :OLD.kw_id,
                    :OLD.ch_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    :OLD.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."ITKWAS_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger ITKWAS_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."ITKWAS_OI" 
   BEFORE INSERT
   ON ITKWAS
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Itkwas_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO ITKWAS_h
                  ( kw_id,
                    ch_id,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.kw_id,
                    :NEW.ch_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."ITKWAS_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger ITKWAS_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."ITKWAS_OU" 
   BEFORE UPDATE
   ON ITKWAS
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'ITKWAS_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO ITKWAS_h
                  ( kw_id,
                    ch_id,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.kw_id,
                    :NEW.ch_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."ITKWAS_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger ITKWCH_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."ITKWCH_OU" BEFORE UPDATE OF description ON ITKWCH REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 BEGIN
  UPDATE specification_kw SET kw_value = :new.description
  WHERE kw_value = :old.description;
  UPDATE frame_kw SET kw_value = :new.description
  WHERE kw_value = :old.description;
  UPDATE itoikw SET kw_value = :new.description
  WHERE kw_value = :old.description;
  UPDATE ref_text_kw SET kw_value = :new.description
  WHERE kw_value = :old.description;
  UPDATE itkwflt SET kw_value = :new.description
  WHERE kw_value = :old.description;
  UPDATE itkwflt SET kw_value_list = :new.description
  WHERE kw_value_list = :old.description;
END;
/
ALTER TRIGGER "INTERSPC"."ITKWCH_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger ITOID_BIU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."ITOID_BIU" 
   BEFORE INSERT OR UPDATE
   ON itoid
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnFileSize                    itoid.file_size%TYPE := NULL;
BEGIN
   BEGIN
      --L53 Start
      IF (:NEW.revision > 1)
      THEN
          SELECT (   LENGTH( DESKTOP_OBJECT )
               / 1024 )
        INTO lnFileSize
        FROM itoiraw
       WHERE object_id = :NEW.object_id
         AND revision = :NEW.revision - 1
         AND owner = :NEW.owner;

      ELSE
      --L53 End
          SELECT (   LENGTH( DESKTOP_OBJECT )
               / 1024 )
        INTO lnFileSize
        FROM itoiraw
       WHERE object_id = :NEW.object_id
         AND revision = :NEW.revision
         AND owner = :NEW.owner;
      --L53 Start
      END IF;
      --L53 End
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   :NEW.file_size := lnFileSize;
END;
/
ALTER TRIGGER "INTERSPC"."ITOID_BIU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger ITOIH_AI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."ITOIH_AI" 
   AFTER INSERT
   ON ITOIH
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'ItOih_Ai';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF :NEW.lang_id = 1
   THEN
      INSERT INTO itoid
                  ( object_id,
                    revision,
                    created_on,
                    created_by,
                    last_modified_on,
                    last_modified_by,
                    status,
                    owner )
           VALUES ( :NEW.object_id,
                    1,
                    SYSDATE,
                    UPPER( iapiGeneral.SESSION.ApplicationUser.UserId ),
                    SYSDATE,
                    UPPER( iapiGeneral.SESSION.ApplicationUser.UserId ),
                    1,
                    :NEW.owner );

      INSERT INTO itoiraw
                  ( object_id,
                    revision,
                    owner )
           VALUES ( :NEW.object_id,
                    1,
                    :NEW.owner );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."ITOIH_AI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger ITOIH_BD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."ITOIH_BD" BEFORE  DELETE  ON ITOIH REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 DECLARE
        v_count number(4);
BEGIN
   v_count := 0;
      SELECT Count(status)
      INTO v_count
      FROM itoid
      WHERE object_id = :old.object_id
      AND owner = :old.owner
      AND status <> 1 ;
      IF v_count = 0 THEN
         DELETE FROM itoiraw
               WHERE object_id = :old.object_id
                 AND owner = :old.owner ;
         DELETE FROM itoikw
               WHERE object_id = :old.object_id
                 AND owner = :old.owner ;
         DELETE FROM itoid
               WHERE object_id = :old.object_id
                 AND owner = :old.owner ;
   ELSE
      raise_application_error(-20400, 'Cannot Delete Object');
   END IF ;
END;
/
ALTER TRIGGER "INTERSPC"."ITOIH_BD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger PED_IN_SYNC
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."PED_IN_SYNC" 
BEFORE UPDATE
ON SPECIFICATION_HEADER
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
/******************************************************************************
   NAME:       PED_IN_SYNC
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2/13/2013      Rody       1. Created this trigger.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     PED_IN_SYNC
      Sysdate:         2/13/2013
      Date and Time:   2/13/2013, 4:31:30 PM, and 2/13/2013 4:31:30 PM
      Username:        Rody (set in TOAD Options, Proc Templates)
      Table Name:      SPECIFICATION_HEADER (set in the "New PL/SQL Object" dialog)

To prevent behaviour as described in AP01183971 this trigger has been implemented as workaround:

AP01183971     PED in the sync flag is switched off when doing a manual status change to Current 
Description     When manually changing the status of a specification that has a BoM, the PED in the sync flag (specification header) is switched off. However, the BoM PED is correctly changed, meaning that the specification is actually in sync. This only happens when manually doing a status change to Current; the auto status job does not cause this problem. 
Conclusion     In the StatusChange function, when the status is changed to Current and no phase, and bomHeader_PED is not the Sysdate (meaning no manual adjustments in the BoM PED screen to TODAY), then before calling the SetPedInSync function, the value of the specificationHeader_PED is updated to Sysdate. 


******************************************************************************/
BEGIN
  
   -- PED_IN_SYNC flag is always 'Y'
   :NEW.PED_IN_SYNC := 'Y';
    
   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END PED_IN_SYNC;

/
ALTER TRIGGER "INTERSPC"."PED_IN_SYNC" ENABLE;
--------------------------------------------------------
--  DDL for Trigger PROPERTY_ASSOCIATION_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."PROPERTY_ASSOCIATION_AD" 
   BEFORE DELETE
   ON PROPERTY_ASSOCIATION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Property_Association_Ad';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO property_association_h
                  ( property,
                    association,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :OLD.property,
                    :OLD.association,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    :OLD.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."PROPERTY_ASSOCIATION_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger PROPERTY_ASSOCIATION_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."PROPERTY_ASSOCIATION_OI" 
   BEFORE INSERT
   ON PROPERTY_ASSOCIATION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Property_Association_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO property_association_h
                  ( property,
                    association,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.property,
                    :NEW.association,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."PROPERTY_ASSOCIATION_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger PROPERTY_ASSOCIATION_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."PROPERTY_ASSOCIATION_OU" 
   BEFORE UPDATE
   ON PROPERTY_ASSOCIATION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Property_Association_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO property_association_h
                  ( property,
                    association,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.property,
                    :NEW.association,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."PROPERTY_ASSOCIATION_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger PROPERTY_DISPLAY_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."PROPERTY_DISPLAY_AD" 
   BEFORE DELETE
   ON PROPERTY_DISPLAY
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'PROPERTY_DISPLAY_AD',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO property_display_h
                  ( property,
                    display_format,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :OLD.property,
                    :OLD.display_format,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    :OLD.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."PROPERTY_DISPLAY_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger PROPERTY_DISPLAY_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."PROPERTY_DISPLAY_OI" 
   BEFORE INSERT
   ON PROPERTY_DISPLAY
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lsSource                      iapiType.Source_Type := 'Property_Display_Oi';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO property_display_h
                  ( property,
                    display_format,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.property,
                    :NEW.display_format,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."PROPERTY_DISPLAY_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger PROPERTY_DISPLAY_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."PROPERTY_DISPLAY_OU" 
   BEFORE UPDATE
   ON PROPERTY_DISPLAY
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'PROPERTY_DISPLAY_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO property_display_h
                  ( property,
                    display_format,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.property,
                    :NEW.display_format,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."PROPERTY_DISPLAY_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger PROPERTY_GROUP_DISPLAY_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."PROPERTY_GROUP_DISPLAY_AD" 
   BEFORE DELETE
   ON PROPERTY_GROUP_DISPLAY
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Property_Group_Display_Ad';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO property_group_display_h
                  ( property_group,
                    display_format,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :OLD.property_group,
                    :OLD.display_format,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    :OLD.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."PROPERTY_GROUP_DISPLAY_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger PROPERTY_GROUP_DISPLAY_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."PROPERTY_GROUP_DISPLAY_OI" 
   BEFORE INSERT
   ON PROPERTY_GROUP_DISPLAY
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Property_Group_Display_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO property_group_display_h
                  ( property_group,
                    display_format,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.property_group,
                    :NEW.display_format,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."PROPERTY_GROUP_DISPLAY_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger PROPERTY_GROUP_DISPLAY_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."PROPERTY_GROUP_DISPLAY_OU" 
   BEFORE UPDATE
   ON PROPERTY_GROUP_DISPLAY
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Property_Group_Display_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO property_group_display_h
                  ( property_group,
                    display_format,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.property_group,
                    :NEW.display_format,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."PROPERTY_GROUP_DISPLAY_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger PROPERTY_TEST_METHOD_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."PROPERTY_TEST_METHOD_AD" 
   BEFORE DELETE
   ON PROPERTY_TEST_METHOD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Property_Test_Method_Ad';
   lnRetVal                      iapiType.ErrorNum_Type;
   --AP00975410
   lnCount                       iapiType.NumVal_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   --AP00975410 Start
   --check if the property-testMethod assotiation is in 'usage' or not
   --it is in usage if exists a frame in Dev/Current status using this testM as
   --default testM for the property (a new spec can be created which can be edited
   --and the error appears)
   SELECT COUNT(*)
    INTO lnCount
    FROM frame_header fh, FRAME_PROP fp
    WHERE fh.FRAME_NO = fp.FRAME_NO
        AND fh.REVISION = fp.REVISION
        AND fh.OWNER = fp.OWNER
        AND fh.status IN (1, 2) --in dev, current
        AND fp.PROPERTY = :OLD.property
        AND fp.TEST_METHOD = :OLD.test_method;

   IF lnCount > 0
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_TMASSIGNEDTOPROPINUSAGE,
                                            f_tmh_descr(1, :OLD.test_method, 0),
                                            f_rfh_descr(-1, iapiConstant.SECTIONTYPE_SINGLEPROPERTY, :OLD.property, 0, -1) );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                              iapiGeneral.GetLastErrorText( ) );
   END IF;
   --AP00975410 End

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO property_test_method_h
                  ( property,
                    test_method,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :OLD.property,
                    :OLD.test_method,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    :OLD.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."PROPERTY_TEST_METHOD_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger PROPERTY_TEST_METHOD_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."PROPERTY_TEST_METHOD_OI" 
   BEFORE INSERT
   ON PROPERTY_TEST_METHOD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Property_Test_Method_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO property_test_method_h
                  ( property,
                    test_method,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.property,
                    :NEW.test_method,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."PROPERTY_TEST_METHOD_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger PROPERTY_TEST_METHOD_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."PROPERTY_TEST_METHOD_OU" 
   BEFORE UPDATE
   ON PROPERTY_TEST_METHOD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Property_Test_Method_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO property_test_method_h
                  ( property,
                    test_method,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.property,
                    :NEW.test_method,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."PROPERTY_TEST_METHOD_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger REF_TEXT_TYPE_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."REF_TEXT_TYPE_AD" AFTER DELETE ON REF_TEXT_TYPE REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 DECLARE
l_owner interspc_cfg.parameter_data%TYPE;
BEGIN
      SELECT parameter_data
      INTO l_owner
      FROM interspc_cfg
      WHERE parameter = 'owner';
      IF l_owner = :old.owner THEN
         DELETE FROM reference_text
                 WHERE ref_text_type = :old.ref_text_type
                   AND owner = :old.owner ;
         DELETE FROM ref_text_kw
                 WHERE ref_text_type = :old.ref_text_type
                   AND owner = :old.owner ;
      END IF;
END;

/
ALTER TRIGGER "INTERSPC"."REF_TEXT_TYPE_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger REF_TEXT_TYPE_AI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."REF_TEXT_TYPE_AI" 
   AFTER INSERT
   ON REF_TEXT_TYPE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Ref_Text_Type_Ai';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF :NEW.lang_id = 1
   THEN
      INSERT INTO reference_text
                  ( ref_text_type,
                    text_revision,
                    created_on,
                    created_by,
                    last_modified_on,
                    last_edited_by,
                    status,
                    owner )
           VALUES ( :NEW.ref_text_type,
                    1,
                    SYSDATE,
                    UPPER( iapiGeneral.SESSION.ApplicationUser.UserId ),
                    SYSDATE,
                    UPPER( iapiGeneral.SESSION.ApplicationUser.UserId ),
                    1,
                    :NEW.owner );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."REF_TEXT_TYPE_AI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RGI_ACCESSGROUPINSERT
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."RGI_ACCESSGROUPINSERT" 
	AFTER INSERT ON ACCESS_GROUP
	REFERENCING NEW AS newRow
	FOR EACH ROW
DECLARE
	lnUserGroupId	NUMBER;
BEGIN
  SELECT USER_GROUP_ID
  	INTO lnUserGroupId 
    FROM USER_GROUP 
   WHERE SHORT_DESC = 'RM_GRP';
  if lnUserGroupId IS NOT NULL then
  	 INSERT INTO USER_ACCESS_GROUP ( "ACCESS_GROUP", USER_GROUP_ID, UPDATE_ALLOWED, MRP_UPDATE ) 
     	VALUES (:newRow.ACCESS_GROUP, lnUserGroupId, 'N', 'N');
  end if;
END;


/
ALTER TRIGGER "INTERSPC"."RGI_ACCESSGROUPINSERT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RGI_ONLOGON
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."RGI_ONLOGON" 
after logon on database
declare lnRetVal	   NUMBER;
 		  lsProgram	   VARCHAR2(256);
begin
 	if USERENV( 'sessionid' ) <> 0 then
	 SELECT PROGRAM
	 INTO lsProgram  
     	 FROM V$SESSION
     	 WHERE AUDSID = USERENV( 'sessionid' );  
	 if lower(lsProgram) IN ('busobj.exe','fcproc.exe','jobserverchild.exe','wireportserver.exe') then
 	 	iapigeneral.enablelogging();
	 	iapigeneral.loginfo('RmApi_ReportManager','RGI_OnLogon','SETCONNECTION(' || user || ')', iapiConstant.INFOLEVEL_3);
	 	iapigeneral.disablelogging();
	 	lnRetVal := IAPIGENERAL.SETCONNECTION(user,'Report Manager');
	 end if;
 	end if;
end;


/
ALTER TRIGGER "INTERSPC"."RGI_ONLOGON" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RGI_SETTINGS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."RGI_SETTINGS" 
AFTER DELETE OR INSERT OR UPDATE
ON RMtSETTINGS
REFERENCING NEW AS newRow OLD AS oldRow
FOR EACH ROW
DECLARE	
  NewPath VARCHAR2(255) := :newRow.VALUE;
  OldPath VARCHAR2(255) := :oldRow.VALUE;
  UserName VARCHAR2(255);
BEGIN
  select OWNER into UserName from dba_objects where object_name='AOPA_BLOB' AND OBJECT_TYPE='PACKAGE';
  IF upper(:newRow.SETTING) = 'DESTINATIONFOLDER' THEN
    IF length(OldPath) > 0 THEN
      IF OldPath <> '_' THEN
        iapiGeneral.LogInfo('Report Manager','RGI_SETTINGS','Removing authorization for ' || user || ' to use ' || OldPath,3);
        DBMS_JAVA.REVOKE_PERMISSION( UserName, 'SYS:java.io.FilePermission', OldPath || '*', 'write' );
      END IF;
      IF length(NewPath) > 0 THEN
        iapiGeneral.LogInfo('Report Manager','RGI_SETTINGS','Granting authorization for ' || user || ' to use ' || NewPath,3);
        DBMS_JAVA.GRANT_PERMISSION( UserName, 'SYS:java.io.FilePermission', NewPath || '*', 'write' );
	  END IF;
    END IF;  
  END IF;
END RGI_SETTINGS;


/
ALTER TRIGGER "INTERSPC"."RGI_SETTINGS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger RNDTFWBINGREDIENTSNEW_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."RNDTFWBINGREDIENTSNEW_OI" 
   BEFORE INSERT
   ON RNDTFWBINGREDIENTSNEW    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'RNDTFWBINGREDIENTSNEW_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
   lnRecFac                      specification_ing.recfac%TYPE;
   lnSpecRecFac                  specification_ing.recfac%TYPE;
   lnRecIng                      iting.rec_ing%TYPE;
   lnOrigIng                     iting.org_ing%TYPE;
	 --TFS7146 one line
	 lnErrorMessage                iapitype.ErrorMessage_Type;
BEGIN

   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   BEGIN

        SELECT recfac, rec_ing, org_ing
        INTO lnRecFac, lnRecIng, lnOrigIng
        FROM iting WHERE
        ingredient = :NEW.ingredient;


      BEGIN
        SELECT recfac
        INTO lnSpecRecFac
        FROM specification_ing
        WHERE ingredient = :NEW.ingredient
          AND part_no = :NEW.partno
          AND revision = :NEW.revision
          AND hier_level = 1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          lnSpecRecFac := NULL;
      END;


        IF lnSpecRecFac IS NULL THEN
            :NEW.RECONSTITUTIONFACTOR := lnRecFac;
        ELSE
            :NEW.RECONSTITUTIONFACTOR := lnSpecRecFac;
        END IF;

        :NEW.RECONSTITUTIONINGREDIENT := lnRecIng;
        :NEW.RECONSTITUTIONINGREDDESC := f_ing_descr(1, lnRecIng, 0);
        :NEW.ORIGINALINGREDIENT := lnOrigIng;
        :NEW.ORIGINALINGREDIENTDESC := f_ing_descr(1, lnOrigIng, 0);

   EXCEPTION
      WHEN OTHERS
      THEN
   NULL;
--TFS7146 start
	       lnErrorMessage := 'Could not load the ingredient reconstitution for '
				                   ||' part_no = <'
													 ||:NEW.partno
													 ||'> '
                           ||' revision = <'
                           ||:NEW.revision
                           ||'> '
                           ||' ingredient = <'
                           ||:NEW.ingredient
                           ||'> '
                           ||' sequence = <'
                           ||:NEW.sequence
                           ||'> '
                           ||' hierarchical level = <'
                           ||:NEW.hierarchicallevel
                           ||'> ';
--TFS7146 end
         iapiGeneral.LogError( lsSource,
                               '',
															 --TFS 7146 one line
															 lnErrorMessage);
                               --SQLERRM );      --orig
   END;
END;
/
ALTER TRIGGER "INTERSPC"."RNDTFWBINGREDIENTSNEW_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger STAGE_DISPLAY_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."STAGE_DISPLAY_AD" 
   BEFORE DELETE
   ON STAGE_DISPLAY
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Stage_Display_Ad';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF    (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
           AND :OLD.intl = '0' )
      OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' )
   THEN
      INSERT INTO stage_display_h
                  ( stage,
                    display_format,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :OLD.stage,
                    :OLD.display_format,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    :OLD.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."STAGE_DISPLAY_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger STAGE_DISPLAY_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."STAGE_DISPLAY_OI" 
   BEFORE INSERT
   ON STAGE_DISPLAY
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Stage_Display_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
              AND :NEW.intl = '0' )
        OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
   THEN
      INSERT INTO stage_display_h
                  ( stage,
                    display_format,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.stage,
                    :NEW.display_format,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."STAGE_DISPLAY_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger STAGE_DISPLAY_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."STAGE_DISPLAY_OU" 
   BEFORE UPDATE
   ON STAGE_DISPLAY
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Stage_Display_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF    (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
           AND :NEW.intl = '0' )
      OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' )
   THEN
      INSERT INTO stage_display_h
                  ( stage,
                    display_format,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.stage,
                    :NEW.display_format,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."STAGE_DISPLAY_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TEST_METHOD_CONDITION_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TEST_METHOD_CONDITION_AD" 
   BEFORE DELETE
   ON TEST_METHOD_CONDITION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TEST_METHOD_CONDITION_AD',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO TEST_METHOD_CONDITION_H
                  ( test_method,
                    set_no,
                    condition,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :OLD.test_method,
                    :OLD.set_no,
                    :OLD.condition,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    :OLD.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TEST_METHOD_CONDITION_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TEST_METHOD_CONDITION_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TEST_METHOD_CONDITION_OI" 
   BEFORE INSERT
   ON TEST_METHOD_CONDITION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TEST_METHOD_CONDITION_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO TEST_METHOD_CONDITION_H
                  ( test_method,
                    set_no,
                    condition,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.test_method,
                    :NEW.set_no,
                    :NEW.condition,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TEST_METHOD_CONDITION_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TEST_METHOD_CONDITION_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TEST_METHOD_CONDITION_OU" 
   BEFORE UPDATE
   ON TEST_METHOD_CONDITION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TEST_METHOD_CONDITION_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO TEST_METHOD_CONDITION_H
                  ( test_method,
                    set_no,
                    condition,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.test_method,
                    :NEW.set_no,
                    :NEW.condition,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TEST_METHOD_CONDITION_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ACCESS_GROUP_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ACCESS_GROUP_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON access_group
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   access_group%ROWTYPE;
   lrNewRecord                   access_group%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_ACCESS_GROUP_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.access_group := :OLD.access_group;
   lrOldRecord.sort_desc := :OLD.sort_desc;
   lrOldRecord.description := :OLD.description;
   lrNewRecord.access_group := :NEW.access_group;
   lrNewRecord.sort_desc := :NEW.sort_desc;
   lrNewRecord.description := :NEW.description;
   lnRetVal := iapiAuditTrail.AddAccessGroupHistory( lsAction,
                                                     lrOldRecord,
                                                     lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ACCESS_GROUP_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_AD_ITSAPPLANTRANGE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_AD_ITSAPPLANTRANGE" AFTER DELETE ON ITSAPPLRANGE FOR EACH ROW
DECLARE
BEGIN
  DELETE ITSAPPLRANGE_SS WHERE rangeid = :old.id;
END TR_AD_ITSAPPLANTRANGE;
/
ALTER TRIGGER "INTERSPC"."TR_AD_ITSAPPLANTRANGE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_AITUP_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_AITUP_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON itup
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   itup%ROWTYPE;
   lrNewRecord                   itup%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_AITUP_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.user_id := :OLD.user_id;
   lrOldRecord.plant := :OLD.plant;
   lrNewRecord.user_id := :NEW.user_id;
   lrNewRecord.plant := :NEW.plant;
   lnRetVal := iapiAuditTrail.AddUserHsAddUserPlant( lsAction,
                                                     lrOldRecord,
                                                     lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_AITUP_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ASSOCIATION_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ASSOCIATION_OI" 
   BEFORE INSERT
   ON ASSOCIATION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lsSource                      iapiType.Source_Type := 'Tr_Association_Oi';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE association_h
         SET max_rev = 0
       WHERE association = :NEW.association;

      INSERT INTO ASSOCIATION_H
                  ( association,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    association_type,
                    max_rev )
           VALUES ( :NEW.association,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.association_type,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ASSOCIATION_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ASSOCIATION_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ASSOCIATION_OU" 
   AFTER UPDATE OF description, association_type, status
   ON ASSOCIATION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ASSOCIATION_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND (    :OLD.description <> :NEW.description
            OR :OLD.association_type <> :NEW.association_type )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM association_h
       WHERE association = :NEW.association
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE association_h
         SET max_rev = 0
       WHERE association = :NEW.association
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM ASSOCIATION_H
       WHERE association = :NEW.association;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ASSOCIATION_H
                  ( association,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    association_type,
                    max_rev )
           VALUES ( :NEW.association,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.association_type,
                    1 );

      INSERT INTO ASSOCIATION_H
                  ( association,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    association_type,
                    max_rev )
         SELECT :NEW.association,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                association_type,
                --IS190 --max_rev --orig
                1
           FROM association_h
          WHERE association = :NEW.association
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'as',
                    :NEW.association,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ASSOCIATION_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ASSOCIATION_STATUS_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ASSOCIATION_STATUS_OU" 
   AFTER UPDATE OF status
   ON ASSOCIATION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ASSOCIATION_STATUS_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
 -- IS194
   IF :OLD.status <> :NEW.status
   THEN
      UPDATE ITINGDETAILCONFIG
      SET status = :NEW.status
      WHERE ingdetail_association = :OLD.association;
   END IF;

END;
/
ALTER TRIGGER "INTERSPC"."TR_ASSOCIATION_STATUS_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ATTR_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ATTR_OI" 
   BEFORE INSERT
   ON ATTRIBUTE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorTextAndLoginfo( 'TR_ATTR_OI',
                                                      '',
                                                      iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ATTR_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE attribute_h
         SET max_rev = 0
       WHERE ATTRIBUTE = :NEW.ATTRIBUTE;

      INSERT INTO ATTRIBUTE_H
                  ( ATTRIBUTE,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.ATTRIBUTE,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ATTR_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ATTR_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ATTR_OU" 
   AFTER UPDATE OF description, status
   ON ATTRIBUTE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_bubble                      VARCHAR2( 1000 );
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorTextAndLoginfo( 'TR_ATTR_OU',
                                                      '',
                                                      iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ATTR_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.description <> :NEW.description
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      BEGIN
         SELECT revision
           INTO l_revision
           FROM attribute_h
          WHERE ATTRIBUTE = :NEW.ATTRIBUTE
            AND max_rev = 1
            AND lang_id = 1;

         UPDATE attribute_h
            SET max_rev = 0
          WHERE ATTRIBUTE = :NEW.ATTRIBUTE
            AND max_rev = 1;

         SELECT (    (   TRUNC(   MAX( revision )
                                / 100 )
                       + 1 )
                  * 100 )
           INTO l_next_val
           FROM ATTRIBUTE_H
          WHERE ATTRIBUTE = :NEW.ATTRIBUTE;

         IF l_next_val IS NULL
         THEN
            l_next_val := 1;
         END IF;

         INSERT INTO ATTRIBUTE_H
                     ( ATTRIBUTE,
                       revision,
                       lang_id,
                       description,
                       last_modified_on,
                       last_modified_by,
                       max_rev )
              VALUES ( :NEW.ATTRIBUTE,
                       l_next_val,
                       1,
                       :NEW.description,
                       SYSDATE,
                       iapiGeneral.SESSION.ApplicationUser.UserId,
                       1 );

         INSERT INTO ATTRIBUTE_H
                     ( ATTRIBUTE,
                       revision,
                       lang_id,
                       description,
                       last_modified_on,
                       last_modified_by,
                       max_rev )
            SELECT :NEW.ATTRIBUTE,
                   l_next_val,
                   lang_id,
                   description,
                   last_modified_on,
                   last_modified_by,
                   --IS190 --max_rev --orig
                   1
              FROM attribute_h
             WHERE ATTRIBUTE = :NEW.ATTRIBUTE
               AND revision = l_revision
               AND lang_id <> 1;

         SELECT MAX( revision )
           INTO l_revision
           FROM attribute_b
          WHERE revision < l_next_val
            AND ATTRIBUTE = :NEW.ATTRIBUTE
            AND lang_id = 1;

         IF l_revision IS NOT NULL
         THEN
            SELECT bubble
              INTO l_bubble
              FROM attribute_b
             WHERE revision = l_revision
               AND lang_id = 1
               AND ATTRIBUTE = :NEW.ATTRIBUTE;

            INSERT INTO attribute_b
                        ( ATTRIBUTE,
                          revision,
                          lang_id,
                          bubble,
                          last_modified_on,
                          last_modified_by )
                 VALUES ( :NEW.ATTRIBUTE,
                          l_next_val,
                          1,
                          l_bubble,
                          SYSDATE,
                          iapiGeneral.SESSION.ApplicationUser.UserId );
         END IF;
      END;
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :NEW.status <> :OLD.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'at',
                    :NEW.ATTRIBUTE,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ATTR_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_BOM_LAYOUT_DEL
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_BOM_LAYOUT_DEL" 
   BEFORE DELETE
   ON ITBOMLY
   FOR EACH ROW
BEGIN
   DELETE FROM ITBOMLYITEM
         WHERE layout_id = :OLD.layout_id
           AND revision = :OLD.revision;
EXCEPTION
   WHEN OTHERS
   THEN
      iapiGeneral.LogError( 'TR_BOM_LAYOUT_DEL',
                            '',
                            SQLERRM );
END;
/
ALTER TRIGGER "INTERSPC"."TR_BOM_LAYOUT_DEL" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_CHARACTERISTIC_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_CHARACTERISTIC_OI" 
   BEFORE INSERT
   ON CHARACTERISTIC
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Characteristic_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE characteristic_h
         SET max_rev = 0
       WHERE characteristic_id = :NEW.characteristic_id;

      INSERT INTO CHARACTERISTIC_H
                  ( characteristic_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.characteristic_id,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_CHARACTERISTIC_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_CHARACTERISTIC_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_CHARACTERISTIC_OU" 
   AFTER UPDATE OF description, status
   ON CHARACTERISTIC
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_bubble                      VARCHAR2( 1000 );
   l_revision                    NUMBER;
   lsSource                      iapiType.Source_Type := 'Tr_Characteristic_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.description <> :NEW.description
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM characteristic_h
       WHERE characteristic_id = :NEW.characteristic_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE characteristic_h
         SET max_rev = 0
       WHERE characteristic_id = :NEW.characteristic_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM CHARACTERISTIC_H
       WHERE characteristic_id = :NEW.characteristic_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO CHARACTERISTIC_H
                  ( characteristic_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.characteristic_id,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO CHARACTERISTIC_H
                  ( characteristic_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.characteristic_id,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                1
           FROM characteristic_h
          WHERE characteristic_id = :NEW.characteristic_id
            AND revision = l_revision
            AND lang_id <> 1;

      SELECT MAX( revision )
        INTO l_revision
        FROM characteristic_b
       WHERE revision < l_next_val
         AND characteristic_id = :NEW.characteristic_id
         AND lang_id = 1;

      IF l_revision IS NOT NULL
      THEN
         SELECT bubble
           INTO l_bubble
           FROM characteristic_b
          WHERE revision = l_revision
            AND lang_id = 1
            AND characteristic_id = :NEW.characteristic_id;

         INSERT INTO characteristic_b
                     ( characteristic_id,
                       revision,
                       lang_id,
                       bubble,
                       last_modified_on,
                       last_modified_by )
              VALUES ( :NEW.characteristic_id,
                       l_next_val,
                       1,
                       l_bubble,
                       SYSDATE,
                       iapiGeneral.SESSION.ApplicationUser.UserId );
      END IF;
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'ch',
                    :NEW.characteristic_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_CHARACTERISTIC_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_CHARACTERISTIC_STATUS_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_CHARACTERISTIC_STATUS_OU" 
   AFTER UPDATE OF status
   ON CHARACTERISTIC
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_CHARACTERISTIC_STATUS_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF :OLD.status <> :NEW.status
   THEN
      UPDATE ITINGDETAILCONFIG_CHARASSOC
      SET status = :NEW.status
      WHERE ingdetail_characteristic = :OLD.characteristic_id;
   END IF;

END;
/
ALTER TRIGGER "INTERSPC"."TR_CHARACTERISTIC_STATUS_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_CLASS3_HISTORIC
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_CLASS3_HISTORIC" 
   AFTER UPDATE OF STATUS
   ON CLASS3
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Class3_Historic';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF (     :NEW.status <> :OLD.status
        AND :NEW.Status = 1 )
   THEN
      lnRetVal := iapiEvent.SinkEvent( iapiConstant.SpecTypeHistoric,
                                          TO_CHAR( :NEW.CLASS )
                                       || '|'
                                       || :NEW.SORT_DESC );

      IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.LogError( lsSource,
                               '',
                               iapiGeneral.GetLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_CLASS3_HISTORIC" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_CLASS3_NEW
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_CLASS3_NEW" 
   AFTER INSERT
   ON CLASS3
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Class3_New';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   lnRetVal := iapiEvent.SinkEvent( iapiConstant.SpecTypeCreated,
                                       TO_CHAR( :NEW.CLASS )
                                    || '|'
                                    || :NEW.SORT_DESC );

   IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_CLASS3_NEW" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_CLASS3_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_CLASS3_OI" 
   BEFORE INSERT
   ON CLASS3
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorTextAndLoginfo( 'TR_CLASS3_OI',
                                                      '',
                                                      iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_CLASS3_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE class3_h
         SET max_rev = 0
       WHERE CLASS = :NEW.CLASS;

      INSERT INTO CLASS3_H
                  ( CLASS,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    TYPE,
                    sort_desc,
                    max_rev )
           VALUES ( :NEW.CLASS,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.TYPE,
                    :NEW.sort_desc,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_CLASS3_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_CLASS3_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_CLASS3_OU" 
   AFTER UPDATE OF description, TYPE, status, sort_desc
   ON CLASS3
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_revision                    NUMBER;
   l_next_val                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorTextAndLoginfo( 'TR_CLASS3_OU',
                                                      '',
                                                      iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_CLASS3_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND (    :OLD.description <> :NEW.description
            OR :OLD.TYPE <> :NEW.TYPE
            OR :OLD.sort_desc <> :NEW.sort_desc )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM class3_h
       WHERE CLASS = :NEW.CLASS
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE class3_h
         SET max_rev = 0
       WHERE CLASS = :NEW.CLASS
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM CLASS3_H
       WHERE CLASS = :NEW.CLASS;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO CLASS3_H
                  ( CLASS,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    TYPE,
                    sort_desc,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.CLASS,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    :NEW.TYPE,
                    :NEW.sort_desc,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO CLASS3_H
                  ( CLASS,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    TYPE,
                    sort_desc,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.CLASS,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                TYPE,
                sort_desc,
                last_modified_by,
                1
           FROM class3_h
          WHERE CLASS = :NEW.CLASS
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'c3',
                    :NEW.CLASS,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_CLASS3_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_CONDITION_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_CONDITION_OI" 
   BEFORE INSERT
   ON CONDITION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_CONDITION_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE CONDITION_h
         SET max_rev = 0
       WHERE CONDITION = :NEW.CONDITION;

      INSERT INTO CONDITION_H
                  ( CONDITION,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.CONDITION,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_CONDITION_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_CONDITION_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_CONDITION_OU" 
   AFTER UPDATE OF description, status
   ON CONDITION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_revision                    NUMBER;
   l_next_val                    NUMBER;
   lsSource                      iapiType.Source_Type := 'Tr_Condition_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM condition_h
       WHERE condition = :NEW.condition
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE CONDITION_h
         SET max_rev = 0
       WHERE CONDITION = :NEW.CONDITION
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM CONDITION_H
       WHERE CONDITION = :NEW.CONDITION;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO CONDITION_H
                  ( CONDITION,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.CONDITION,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO CONDITION_H
                  ( CONDITION,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.condition,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                1
           FROM condition_h
          WHERE condition = :NEW.condition
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'cd',
                    :NEW.CONDITION,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_CONDITION_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FRAME_HEADER_AU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FRAME_HEADER_AU" 
   AFTER UPDATE
   ON FRAME_HEADER
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_FRAME_HEADER_AU';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   /* Trigger that synchronises the validation rules when frame becomes current */
   IF     ( :NEW.status <> :OLD.status )
      AND ( :NEW.status = 2 )
   THEN
      lnRetVal := iapiFrame.SynchroniseValidation( :NEW.frame_no,
                                                   :NEW.revision,
                                                   :NEW.owner );

      IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.logError( lsSource,
                               '',
                               iapiGeneral.getLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_FRAME_HEADER_AU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FRAME_HEADER_BU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FRAME_HEADER_BU" BEFORE  UPDATE  ON FRAME_HEADER REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 DECLARE
l_old_type  class3.type%TYPE;
l_new_type  class3.type%TYPE;
BEGIN
 IF :new.CLASS3_ID <> :old.CLASS3_ID THEN
   IF :old.class3_id <> :new.class3_id THEN
      SELECT type
      INTO l_old_type
      FROM class3
      WHERE class = :old.CLASS3_ID;
      SELECT type
      INTO l_new_type
      FROM class3
      WHERE class = :new.CLASS3_ID;
      IF l_new_type <> l_old_type THEN
         DELETE itfrmcl WHERE frame_no = :new.frame_no AND owner = :new.owner;
      END IF;
   END IF ;
 END IF;
 END;

/
ALTER TRIGGER "INTERSPC"."TR_FRAME_HEADER_BU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FRAME_NEW
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FRAME_NEW" 
   AFTER INSERT
   ON FRAME_HEADER
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Frame_New';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   lnRetVal :=
      iapiEvent.SinkEvent( iapiConstant.FrameCreated,
                              :NEW.frame_no
                           || '|'
                           || TO_CHAR( :NEW.revision*100 )
                           || '|'
                           || TO_CHAR( :NEW.owner )
                           || '|'
                           || f_owner_descr( :NEW.owner ) );

   IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_FRAME_NEW" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FRAME_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FRAME_OD" AFTER  DELETE  ON ITFRMNOTE REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 BEGIN
   UPDATE itfrm_h
   SET last_modified_on = SYSDATE
   WHERE frame_no = :old.frame_no
   AND owner = :old.owner;
END;

/
ALTER TRIGGER "INTERSPC"."TR_FRAME_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FRAME_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FRAME_OI" AFTER  INSERT  ON ITFRMNOTE REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 BEGIN
  BEGIN
     INSERT INTO itfrm_h VALUES (:new.frame_no,:new.owner,SYSDATE);
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN
        UPDATE itfrm_h
        SET last_modified_on = SYSDATE
        WHERE frame_no = :new.frame_no
        AND owner = :new.owner;
  END;
END;

/
ALTER TRIGGER "INTERSPC"."TR_FRAME_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FRAME_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FRAME_OU" AFTER  UPDATE  ON ITFRMNOTE REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 BEGIN
   UPDATE itfrm_h
   SET last_modified_on = SYSDATE
   WHERE frame_no = :old.frame_no
   AND owner = :old.owner;
END;

/
ALTER TRIGGER "INTERSPC"."TR_FRAME_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FRAME_SECTION_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FRAME_SECTION_OD" 
    AFTER  DELETE
    ON FRAME_SECTION
    REFERENCING OLD AS OLD NEW AS NEW
    FOR EACH ROW
 DECLARE
    lnRetVal                      iapiType.ErrorNum_Type;
 BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_USER_GROUP_LIST_BD',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

     IF (:OLD.type = iapiConstant.SECTIONTYPE_INGREDIENTLIST) --9
     THEN
        DELETE FROM frameIngLy
            WHERE frame_no = :OLD.frame_no
            AND revision = :OLD.revision
            AND owner = :OLD.owner;
     END IF;
END;

/
ALTER TRIGGER "INTERSPC"."TR_FRAME_SECTION_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FRAME_STATUS_CHANGE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FRAME_STATUS_CHANGE" 
   AFTER UPDATE OF STATUS
   ON FRAME_HEADER
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Frame_Status_Change';
   lnRetVal                      iapiType.ErrorNum_Type;
   lsOldStatusName               iapitype.String_Type;
   lsNewStatusName               iapitype.String_Type;
BEGIN
   IF ( :NEW.status <> :OLD.status )
   THEN
      CASE :OLD.status
         WHEN 1
         THEN
            lsOldStatusName := 'In Dev';
         WHEN 2
         THEN
            lsOldStatusName := 'Current';
         WHEN 3
         THEN
            lsOldStatusName := 'Historic';
         WHEN 4
         THEN
            lsOldStatusName := 'Obsolete';
         WHEN 5
         THEN
            lsOldStatusName := 'Used';
         WHEN 6
         THEN
            lsOldStatusName := 'Imported';
         WHEN 7
         THEN
            lsOldStatusName := 'Current Intl';
         ELSE
            lsOldStatusName := NULL;
      END CASE;

      CASE :NEW.status
         WHEN 1
         THEN
            lsNewStatusName := 'In Dev';
         WHEN 2
         THEN
            lsNewStatusName := 'Current';
         WHEN 3
         THEN
            lsNewStatusName := 'Historic';
         WHEN 4
         THEN
            lsNewStatusName := 'Obsolete';
         WHEN 5
         THEN
            lsNewStatusName := 'Used';
         WHEN 6
         THEN
            lsNewStatusName := 'Imported';
         WHEN 7
         THEN
            lsNewStatusName := 'Current Intl';
         ELSE
            lsNewStatusName := NULL;
      END CASE;

      lnRetVal :=
         iapiEvent.SinkEvent( iapiConstant.FramestatusChanged,
                                 :NEW.frame_no
                              || '|'
                              || TO_CHAR( :NEW.revision*100 )
                              || '|'
                              || TO_CHAR( :NEW.owner )
                              || '|'
                              || f_owner_descr( :NEW.owner )
                              || '|'
                              || TO_CHAR( :OLD.status )
                              || '|'
                              || lsOldStatusName
                              || '|'
                              || TO_CHAR( :NEW.status )
                              || '|'
                              || lsNewStatusName );

      IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.LogError( lsSource,
                               '',
                               iapiGeneral.GetLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_FRAME_STATUS_CHANGE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FRAMEDATA_SERVER
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FRAMEDATA_SERVER" 
   AFTER INSERT ON FRAMEDATA_SERVER

 BEGIN
  DBMS_ALERT.SIGNAL('SPEC_SERVER', 'SPECDATA_TO_BE_CONVERTED') ;
END ;

/
ALTER TRIGGER "INTERSPC"."TR_FRAMEDATA_SERVER" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FRMCL_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FRMCL_OD" AFTER  DELETE  ON ITFRMCL REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 BEGIN
   UPDATE itfrm_h
   SET last_modified_on = SYSDATE
   WHERE frame_no = :old.frame_no
   AND owner = :old.owner;
END;

/
ALTER TRIGGER "INTERSPC"."TR_FRMCL_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FRMCL_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FRMCL_OI" AFTER  INSERT  ON ITFRMCL REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 BEGIN
   BEGIN
      INSERT INTO itfrm_h VALUES (:new.frame_no,:new.owner,SYSDATE);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         UPDATE itfrm_h
         SET last_modified_on = SYSDATE
         WHERE frame_no = :new.frame_no
         AND owner = :new.owner;
   END;
END;

/
ALTER TRIGGER "INTERSPC"."TR_FRMCL_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FRMCL_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FRMCL_OU" AFTER  UPDATE  ON ITFRMCL REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 BEGIN
   UPDATE itfrm_h
   SET last_modified_on = SYSDATE
   WHERE frame_no = :old.frame_no
   AND owner = :old.owner;
END;

/
ALTER TRIGGER "INTERSPC"."TR_FRMCL_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FRMKW_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FRMKW_OD" AFTER  DELETE  ON FRAME_KW REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 BEGIN
   UPDATE itfrm_h
   SET last_modified_on = SYSDATE
   WHERE frame_no = :old.frame_no
   AND owner = :old.owner;
END;

/
ALTER TRIGGER "INTERSPC"."TR_FRMKW_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FRMKW_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FRMKW_OI" AFTER  INSERT  ON FRAME_KW REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 BEGIN
    BEGIN
       INSERT INTO itfrm_h VALUES (:new.frame_no,:new.owner,SYSDATE);
    EXCEPTION
       WHEN DUP_VAL_ON_INDEX THEN
          UPDATE itfrm_h
          SET last_modified_on = SYSDATE
          WHERE frame_no = :new.frame_no
          AND owner = :new.owner;
    END;
END;

/
ALTER TRIGGER "INTERSPC"."TR_FRMKW_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FRMKW_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FRMKW_OU" AFTER  UPDATE  ON FRAME_KW REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 BEGIN
   UPDATE itfrm_h
   SET last_modified_on = SYSDATE
   WHERE frame_no = :old.frame_no
   AND owner = :old.owner;
END;

/
ALTER TRIGGER "INTERSPC"."TR_FRMKW_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FT_BASE_RULES_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FT_BASE_RULES_OD" 
   BEFORE DELETE
   ON FT_BASE_RULES
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Ft_Base_Rules_Od';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.ft_group_id < 700000 )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO FT_BASE_RULES_H
                  ( ft_group_id,
                    ft_id,
                    old_section,
                    old_sub_section,
                    old_prop_group,
                    old_property,
                    old_attribute,
                    old_column,
                    new_section,
                    new_sub_section,
                    new_prop_group,
                    new_property,
                    new_attribute,
                    new_column,
                    object_type,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :OLD.ft_group_id,
                    :OLD.ft_id,
                    :OLD.old_section,
                    :OLD.old_sub_section,
                    :OLD.old_prop_group,
                    :OLD.old_property,
                    :OLD.old_attribute,
                    :OLD.old_column,
                    :OLD.new_section,
                    :OLD.new_sub_section,
                    :OLD.new_prop_group,
                    :OLD.new_property,
                    :OLD.new_attribute,
                    :OLD.new_column,
                    :OLD.object_type,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D' );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_FT_BASE_RULES_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FT_BASE_RULES_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FT_BASE_RULES_OI" 
   BEFORE INSERT
   ON FT_BASE_RULES
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Ft_Base_Rules_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.ft_group_id < 700000 )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO FT_BASE_RULES_H
                  ( ft_group_id,
                    ft_id,
                    old_section,
                    old_sub_section,
                    old_prop_group,
                    old_property,
                    old_attribute,
                    old_column,
                    new_section,
                    new_sub_section,
                    new_prop_group,
                    new_property,
                    new_attribute,
                    new_column,
                    object_type,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :NEW.ft_group_id,
                    :NEW.ft_id,
                    :NEW.old_section,
                    :NEW.old_sub_section,
                    :NEW.old_prop_group,
                    :NEW.old_property,
                    :NEW.old_attribute,
                    :NEW.old_column,
                    :NEW.new_section,
                    :NEW.new_sub_section,
                    :NEW.new_prop_group,
                    :NEW.new_property,
                    :NEW.new_attribute,
                    :NEW.new_column,
                    :NEW.object_type,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I' );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_FT_BASE_RULES_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FT_BASE_RULES_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FT_BASE_RULES_OU" 
   AFTER UPDATE
   ON FT_BASE_RULES
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Ft_Base_Rules_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.ft_group_id < 700000 )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO FT_BASE_RULES_H
                  ( ft_group_id,
                    ft_id,
                    old_section,
                    old_sub_section,
                    old_prop_group,
                    old_property,
                    old_attribute,
                    old_column,
                    new_section,
                    new_sub_section,
                    new_prop_group,
                    new_property,
                    new_attribute,
                    new_column,
                    object_type,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :NEW.ft_group_id,
                    :NEW.ft_id,
                    :NEW.old_section,
                    :NEW.old_sub_section,
                    :NEW.old_prop_group,
                    :NEW.old_property,
                    :NEW.old_attribute,
                    :NEW.old_column,
                    :NEW.new_section,
                    :NEW.new_sub_section,
                    :NEW.new_prop_group,
                    :NEW.new_property,
                    :NEW.new_attribute,
                    :NEW.new_column,
                    :NEW.object_type,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U' );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_FT_BASE_RULES_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FT_FRAMES_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FT_FRAMES_OD" 
   BEFORE DELETE
   ON FT_FRAMES
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Ft_Frames_Od';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.ft_frame_id < 700000 )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO ft_frames_h
                  ( ft_group_id,
                    ft_frame_id,
                    old_frame_no,
                    old_frame_rev,
                    old_frame_owner,
                    new_frame_no,
                    new_frame_rev,
                    new_frame_owner,
                    old_frame_rev_from,
                    old_frame_rev_to,
                    new_frame_rev_from,
                    new_frame_rev_to,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :OLD.ft_group_id,
                    :OLD.ft_frame_id,
                    :OLD.old_frame_no,
                    :OLD.old_frame_rev,
                    :OLD.old_frame_owner,
                    :OLD.new_frame_no,
                    :OLD.new_frame_rev,
                    :OLD.new_frame_owner,
                    :OLD.old_frame_rev_from,
                    :OLD.old_frame_rev_to,
                    :OLD.new_frame_rev_from,
                    :OLD.new_frame_rev_to,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D' );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_FT_FRAMES_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FT_FRAMES_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FT_FRAMES_OI" 
   BEFORE INSERT
   ON FT_FRAMES
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Ft_Frames_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.ft_frame_id < 700000 )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO ft_frames_h
                  ( ft_group_id,
                    ft_frame_id,
                    old_frame_no,
                    old_frame_rev,
                    old_frame_owner,
                    new_frame_no,
                    new_frame_rev,
                    new_frame_owner,
                    old_frame_rev_from,
                    old_frame_rev_to,
                    new_frame_rev_from,
                    new_frame_rev_to,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :NEW.ft_group_id,
                    :NEW.ft_frame_id,
                    :NEW.old_frame_no,
                    :NEW.old_frame_rev,
                    :NEW.old_frame_owner,
                    :NEW.new_frame_no,
                    :NEW.new_frame_rev,
                    :NEW.new_frame_owner,
                    :NEW.old_frame_rev_from,
                    :NEW.old_frame_rev_to,
                    :NEW.new_frame_rev_from,
                    :NEW.new_frame_rev_to,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I' );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_FT_FRAMES_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FT_FRAMES_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FT_FRAMES_OU" 
   AFTER UPDATE
   ON FT_FRAMES
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Ft_Frames_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.ft_frame_id < 700000 )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO ft_frames_h
                  ( ft_group_id,
                    ft_frame_id,
                    old_frame_no,
                    old_frame_rev,
                    old_frame_owner,
                    new_frame_no,
                    new_frame_rev,
                    new_frame_owner,
                    old_frame_rev_from,
                    old_frame_rev_to,
                    new_frame_rev_from,
                    new_frame_rev_to,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :NEW.ft_group_id,
                    :NEW.ft_frame_id,
                    :NEW.old_frame_no,
                    :NEW.old_frame_rev,
                    :NEW.old_frame_owner,
                    :NEW.new_frame_no,
                    :NEW.new_frame_rev,
                    :NEW.new_frame_owner,
                    :NEW.old_frame_rev_from,
                    :NEW.old_frame_rev_to,
                    :NEW.new_frame_rev_from,
                    :NEW.new_frame_rev_to,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U' );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_FT_FRAMES_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FT_RULE_GROUP_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FT_RULE_GROUP_OD" 
   BEFORE DELETE
   ON FT_RULE_GROUP
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Ft_Rule_Group_Od';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.ft_rule_id < 700000 )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO ft_rule_group_h
                  ( ft_rule_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :OLD.ft_rule_id,
                    :OLD.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D' );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_FT_RULE_GROUP_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FT_RULE_GROUP_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FT_RULE_GROUP_OI" 
   BEFORE INSERT
   ON FT_RULE_GROUP
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Ft_Rule_Group_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.ft_rule_id < 700000 )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO ft_rule_group_h
                  ( ft_rule_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :NEW.ft_rule_id,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I' );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_FT_RULE_GROUP_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FT_RULE_GROUP_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FT_RULE_GROUP_OU" 
   AFTER UPDATE
   ON FT_RULE_GROUP
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Ft_Rule_Group_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.ft_rule_id < 700000 )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO ft_rule_group_h
                  ( ft_rule_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :NEW.ft_rule_id,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U' );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_FT_RULE_GROUP_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FT_SQL_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FT_SQL_OD" 
   BEFORE DELETE
   ON FT_SQL
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Ft_Sql_Od';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.ft_group_id < 700000 )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO FT_SQL_H
                  ( ft_group_id,
                    ft_id,
                    sql_text,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :OLD.ft_group_id,
                    :OLD.ft_id,
                    :OLD.sql_text,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D' );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_FT_SQL_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FT_SQL_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FT_SQL_OI" 
   BEFORE INSERT
   ON FT_SQL
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Ft_Sql_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.ft_group_id < 700000 )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO FT_SQL_H
                  ( ft_group_id,
                    ft_id,
                    sql_text,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :NEW.ft_group_id,
                    :NEW.ft_id,
                    :NEW.sql_text,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I' );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_FT_SQL_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_FT_SQL_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_FT_SQL_OU" 
   AFTER UPDATE
   ON FT_SQL
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Ft_Sql_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.ft_group_id < 700000 )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO FT_SQL_H
                  ( ft_group_id,
                    ft_id,
                    sql_text,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :NEW.ft_group_id,
                    :NEW.ft_id,
                    :NEW.sql_text,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U' );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_FT_SQL_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_HEADER_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_HEADER_OI" 
   BEFORE INSERT
   ON HEADER
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText(iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_HEADER_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE header_h
         SET max_rev = 0
       WHERE header_id = :NEW.header_id;

      INSERT INTO HEADER_H
                  ( header_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.header_id,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_HEADER_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_HEADER_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_HEADER_OU" 
   AFTER UPDATE OF description, status
   ON HEADER
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_bubble                      VARCHAR2( 1000 );
   lnRevision                    iapiType.Revision_Type;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_HEADER_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.description <> :NEW.description
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO lnRevision
        FROM header_h
       WHERE header_id = :NEW.header_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE header_h
         SET max_rev = 0
       WHERE header_id = :NEW.header_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM HEADER_H
       WHERE header_id = :NEW.header_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO HEADER_H
                  ( header_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.header_id,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO HEADER_H
                  ( header_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.header_id,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                1
           FROM header_h
          WHERE header_id = :NEW.header_id
            AND revision = lnRevision
            AND lang_id <> 1;

      SELECT MAX( revision )
        INTO lnRevision
        FROM header_b
       WHERE revision < l_next_val
         AND header_id = :NEW.header_id
         AND lang_id = 1;

      IF lnRevision IS NOT NULL
      THEN
         SELECT bubble
           INTO l_bubble
           FROM header_b
          WHERE revision = lnRevision
            AND lang_id = 1
            AND header_id = :NEW.header_id;

         INSERT INTO header_b
                     ( header_id,
                       revision,
                       lang_id,
                       bubble,
                       last_modified_on,
                       last_modified_by )
              VALUES ( :NEW.header_id,
                       l_next_val,
                       1,
                       l_bubble,
                       SYSDATE,
                       iapiGeneral.SESSION.ApplicationUser.UserId );
      END IF;
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'hd',
                    :NEW.header_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_HEADER_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ING_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ING_OI" 
   BEFORE INSERT
   ON ITING
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow_ing                   interspc_cfg.parameter_data%TYPE;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ING_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow_ing
     FROM interspc_cfg
    WHERE parameter = 'allow_ing'
      AND SECTION = 'interspec';

   IF     l_allow_ing = '1'
      AND (     ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' )
            OR (     :NEW.intl = '0'
                 AND (    iapiGeneral.SESSION.DATABASE.DatabaseType = 'R'
                       OR iapiGeneral.SESSION.DATABASE.DatabaseType = 'L' ) ) )
   THEN
      UPDATE iting_h
         SET max_rev = 0
       WHERE ingredient = :NEW.ingredient;

      INSERT INTO ITING_H
                  ( ingredient,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev,
                    ing_type )
           VALUES ( :NEW.ingredient,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1,
                    :NEW.ing_type );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ING_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ING_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ING_OU" 
   AFTER UPDATE OF description, status, ing_type, recfac, allergen, soi, org_ing, rec_ing
   ON ITING
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_revision                    NUMBER;
   l_next_val                    NUMBER;
   l_allow_ing                   interspc_cfg.parameter_data%TYPE;
   l_allow_ingdet                interspc_cfg.parameter_data%TYPE;
   l_sysdate                     DATE;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ING_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow_ing
     FROM interspc_cfg
    WHERE parameter = 'allow_ing'
      AND SECTION = 'interspec';

   SELECT parameter_data
     INTO l_allow_ingdet
     FROM interspc_cfg
    WHERE parameter = 'allow_ingdet'
      AND SECTION = 'interspec';

   IF     l_allow_ing = '1'
      AND ( :OLD.description <> :NEW.description )
   THEN
      SELECT revision
        INTO l_revision
        FROM iting_h
       WHERE ingredient = :NEW.ingredient
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE iting_h
         SET max_rev = 0
       WHERE ingredient = :NEW.ingredient
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM ITING_H
       WHERE ingredient = :NEW.ingredient;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITING_H
                  ( ingredient,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev,
                    ing_type )
           VALUES ( :NEW.ingredient,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1,
                    :NEW.ing_type );

      INSERT INTO ITING_H
                  ( ingredient,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev,
                    ing_type )
         SELECT :NEW.ingredient,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                1,
                ing_type
           FROM iting_h
          WHERE ingredient = :NEW.ingredient
            AND revision = l_revision
            AND lang_id <> 1;
   /* If ing type changes, don't make a new revision but just set the modified date */
   ELSIF     l_allow_ing = '1'
         AND :OLD.ing_type <> :NEW.ing_type
   THEN
      UPDATE ITING_H
         SET last_modified_on = SYSDATE,
             last_modified_by = iapiGeneral.SESSION.ApplicationUser.UserId,
             ing_type = :NEW.ing_type
       WHERE ingredient = :NEW.ingredient
         AND max_rev = 1;
   ELSIF     l_allow_ing = '1'
         AND :OLD.status <> :NEW.status
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'in',
                    :NEW.ingredient,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;

   IF     l_allow_ingdet = 1
      AND (    :OLD.recfac <> :NEW.recfac
            OR :OLD.allergen <> :NEW.allergen
            OR :OLD.soi <> :NEW.soi
            OR NVL( :OLD.org_ing,
                    -1 ) <> NVL( :NEW.org_ing,
                                 -1 )
            OR NVL( :OLD.rec_ing,
                    -1 ) <> NVL( :NEW.rec_ing,
                                 -1 ) )
   THEN
      -- One of the ingredient details has been updated
      -- This screen is only opened if l_allow_ingdet = 1
      IF (     :NEW.intl = '1'
           AND iapiGeneral.SESSION.DATABASE.DatabaseType = 'R' )
      THEN
         BEGIN
            SELECT   offset
                   + SYSDATE
              INTO l_sysdate
              FROM itdateoffset;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_sysdate := SYSDATE;
         END;

         UPDATE ITING_H
            SET last_modified_on = l_sysdate
          WHERE ingredient = :NEW.ingredient
            AND max_rev = 1;
      ELSE
         UPDATE ITING_H
            SET last_modified_on = SYSDATE
          WHERE ingredient = :NEW.ingredient
            AND max_rev = 1;
      END IF;

      UPDATE ITING_H
         SET last_modified_by = iapiGeneral.SESSION.ApplicationUser.UserId
       WHERE ingredient = :NEW.ingredient
         AND max_rev = 1;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ING_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_INGNOTE_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_INGNOTE_OI" 
   BEFORE INSERT ON ITINGNOTE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorTextAndLoginfo( 'TR_INGNOTE_OU',
                                                      '',
                                                      iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_INGNOTE_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE itingnote_h
         SET max_rev = 0
       WHERE note_id = :NEW.note_id;

      INSERT INTO itingnote_H
                  ( note_id,
                    revision,
                    lang_id,
                    description,
                    text,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.note_id,
                    100,
                    1,
                    :NEW.description,
                    :NEW.text,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_INGNOTE_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_INGNOTE_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_INGNOTE_OU" 
   AFTER UPDATE
   ON ITINGNOTE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
---------------------------------------------------------------------------
-- $Workfile: TR_INGNOTE_OU.sql $
--     Type:  Trigger creation script
----------------------------------------------------------------------------
--   $Author: evoVaLa3 $
-- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
--  $Modtime: 2014-May-05 12:00 $
--   Project: speCX development
----------------------------------------------------------------------------
--  Abstract:
----------------------------------------------------------------------------
DECLARE
   l_next_val                    NUMBER;
   l_bubble                      VARCHAR2( 1000 );
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorTextAndLoginfo( 'TR_INGNOTE_OU',
                                                      '',
                                                      iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_INGNOTE_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND (    :OLD.description <> :NEW.description
            OR (     :OLD.TEXT IS NULL
                 AND :NEW.TEXT IS NOT NULL )
            OR (     :OLD.TEXT IS NOT NULL
                 AND :NEW.TEXT IS NULL )
            OR ( :OLD.TEXT <> :NEW.TEXT ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM itingnote_h
       WHERE note_id = :NEW.note_id
         AND lang_id = 1
         AND max_rev = 1;

      UPDATE itingnote_h
         SET max_rev = 0
       WHERE note_id = :NEW.note_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM itingnote_H
       WHERE note_id = :NEW.note_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO itingnote_H
                  ( note_id,
                    revision,
                    lang_id,
                    description,
                    text,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.note_id,
                    l_next_val,
                    1,
                    :NEW.description,
                    :NEW.TEXT,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO itingnote_H
                  ( note_id,
                    revision,
                    lang_id,
                    description,
                    text,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.note_id,
                l_next_val,
                lang_id,
                description,
                text,
                last_modified_on,
                last_modified_by,
                1
           FROM itingnote_h
          WHERE note_id = :NEW.note_id
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'no',
                    :NEW.note_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );

      NULL;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_INGNOTE_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_INTERSPC_CFG_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_INTERSPC_CFG_AD" 
   AFTER DELETE
   ON INTERSPC_CFG
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsUser                        interspc_cfg_h.user_id%TYPE;
   ldTimeStamp                   interspc_cfg_h.TIMESTAMP%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Interspc_Cfg_Ad';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   lsUser := User;
   ldTimeStamp := SYSDATE;

   INSERT INTO interspc_cfg_h
               ( section,
                 parameter,
                 parameter_data_old,
                 parameter_data_new,
                 action,
                 es_seq_no,
                 user_id,
                 forename,
                 last_name,
                 TIMESTAMP,
                 sign_for_id,
                 sign_for,
                 sign_what_id,
                 sign_what )
        VALUES ( :OLD.section,
                 :OLD.parameter,
                 :OLD.parameter_data,
                 NULL,
                 'D',
                 NULL,
                 lsUser,
                 NULL,
                 NULL,
                 ldTimeStamp,
                 NULL,
                 NULL,
                 NULL,
                 NULL );
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END;
/
ALTER TRIGGER "INTERSPC"."TR_INTERSPC_CFG_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_INTERSPC_CFG_AI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_INTERSPC_CFG_AI" 
   AFTER INSERT
   ON INTERSPC_CFG
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   -- Retrieve es info
   CURSOR lqEs(
      lnEsSeqNo                  IN       iteshs.es_seq_no%TYPE )
   IS
      SELECT user_id,
             forename,
             last_name,
             TIMESTAMP,
             sign_for_id,
             sign_for,
             sign_what_id,
             sign_what
        FROM iteshs
       WHERE es_seq_no = lnEsSeqNo;

   lsUser                        interspc_cfg_h.user_id%TYPE;
   lsForeName                    interspc_cfg_h.forename%TYPE;
   lsLastName                    interspc_cfg_h.last_name%TYPE;
   ldTimeStamp                   interspc_cfg_h.TIMESTAMP%TYPE;
   lsSignForId                   interspc_cfg_h.sign_for_id%TYPE;
   lsSignFor                     interspc_cfg_h.sign_for%TYPE;
   lsSignWhatId                  interspc_cfg_h.sign_what_id%TYPE;
   lsSignWhat                    interspc_cfg_h.sign_what%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Interspc_Cfg_Ai';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   ldTimeStamp := SYSDATE;

   IF     :NEW.es_seq_no IS NOT NULL
      AND :NEW.es_seq_no > 0
   THEN
      -- Fetch es info
      FOR lrEs IN lqEs( :NEW.es_seq_no )
      LOOP
         IF lrEs.user_id IS NULL
         THEN
            IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
            THEN
               lsUser := USER;
            ELSE
               lsUser := iapiGeneral.SESSION.ApplicationUser.UserId;
            END IF;
         ELSE
            lsUser := lrEs.user_id;
         END IF;

         lsForeName := lrEs.forename;
         lsLastName := lrEs.last_name;
         ldTimeStamp := lrEs.TIMESTAMP;
         lsSignForId := lrEs.sign_for_id;
         lsSignFor := lrEs.sign_for;
         lsSignWhatId := lrEs.sign_what_id;
         lsSignWhat := lrEs.sign_what;
      END LOOP;
   ELSE
      IF NOT iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
      THEN
         lsUser := iapiGeneral.SESSION.ApplicationUser.UserId;
         lsForeName := iapiGeneral.SESSION.ApplicationUser.Forename;
         lsLastName := iapiGeneral.SESSION.ApplicationUser.LastName;
      ELSE
         lsUser := USER;
      END IF;

      -- Retrieve for message
      lsSignForId := 'ES_PREFERENCE_CHANGE';
      lnRetVal := iapiAuditTrail.GetMessage( lsSignForId,
                                             :OLD.parameter_data,
                                             :NEW.parameter_data,
                                             NULL,
                                             NULL,
                                             NULL,
                                             lsSignFor );
      -- Retrieve what message
      lsSignWhatId := 'ES_PREFERENCE';
      lnRetVal := iapiAuditTrail.GetMessage( lsSignWhatId,
                                             :NEW.section,
                                             :NEW.parameter,
                                             NULL,
                                             NULL,
                                             NULL,
                                             lsSignWhat );
   END IF;

   INSERT INTO interspc_cfg_h
               ( section,
                 parameter,
                 parameter_data_old,
                 parameter_data_new,
                 action,
                 es_seq_no,
                 user_id,
                 forename,
                 last_name,
                 TIMESTAMP,
                 sign_for_id,
                 sign_for,
                 sign_what_id,
                 sign_what )
        VALUES ( :NEW.section,
                 :NEW.parameter,
                 NULL,
                 :NEW.parameter_data,
                 'I',
                 :NEW.es_seq_no,
                 lsUser,
                 lsForeName,
                 lsLastName,
                 ldTimeStamp,
                 lsSignForId,
                 lsSignFor,
                 lsSignWhatId,
                 lsSignWhat );
EXCEPTION
   WHEN OTHERS
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            SQLERRM );
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
END;
/
ALTER TRIGGER "INTERSPC"."TR_INTERSPC_CFG_AI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_INTERSPC_CFG_AU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_INTERSPC_CFG_AU" 
   AFTER UPDATE
   ON INTERSPC_CFG
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   -- Retrieve es info
   CURSOR lqEs(
      lnEsSeqNo                  IN       iteshs.es_seq_no%TYPE )
   IS
      SELECT user_id,
             forename,
             last_name,
             TIMESTAMP,
             sign_for_id,
             sign_for,
             sign_what_id,
             sign_what
        FROM iteshs
       WHERE es_seq_no = lnEsSeqNo;

   lsUser                        interspc_cfg_h.user_id%TYPE;
   lsForeName                    interspc_cfg_h.forename%TYPE;
   lsLastName                    interspc_cfg_h.last_name%TYPE;
   ldTimeStamp                   interspc_cfg_h.TIMESTAMP%TYPE;
   lsSignForId                   interspc_cfg_h.sign_for_id%TYPE;
   lsSignFor                     interspc_cfg_h.sign_for%TYPE;
   lsSignWhatId                  interspc_cfg_h.sign_what_id%TYPE;
   lsSignWhat                    interspc_cfg_h.sign_what%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Interspc_Cfg_Au';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   ldTimeStamp := SYSDATE;

   IF     :NEW.es_seq_no IS NOT NULL
      AND :NEW.es_seq_no > 0
   THEN
      -- Fetch es info
      FOR lrEs IN lqEs( :NEW.es_seq_no )
      LOOP
         IF lrEs.user_id IS NULL
         THEN
            IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
            THEN
               lsUser := USER;
            ELSE
               lsUser := iapiGeneral.SESSION.ApplicationUser.UserId;
            END IF;
         ELSE
            lsUser := lrEs.user_id;
         END IF;

         lsForeName := lrEs.forename;
         lsLastName := lrEs.last_name;
         ldTimeStamp := lrEs.TIMESTAMP;
         lsSignForId := lrEs.sign_for_id;
         lsSignFor := lrEs.sign_for;
         lsSignWhatId := lrEs.sign_what_id;
         lsSignWhat := lrEs.sign_what;
      END LOOP;
   ELSE
      -- When doing an installation UserId is Null and forename and lastname are not filled in
      IF NOT iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
      THEN
         lsUser := iapiGeneral.SESSION.ApplicationUser.UserId;
         lsForeName := iapiGeneral.SESSION.ApplicationUser.Forename;
         lsLastName := iapiGeneral.SESSION.ApplicationUser.LastName;
      ELSE
         lsUser := USER;
      END IF;

      -- Retrieve for message
      lsSignForId := 'ES_PREFERENCE_CHANGE';
      lnRetVal := iapiAuditTrail.GetMessage( lsSignForId,
                                             :OLD.parameter_data,
                                             :NEW.parameter_data,
                                             NULL,
                                             NULL,
                                             NULL,
                                             lsSignFor );
      -- Retrieve what message
      lsSignWhatId := 'ES_PREFERENCE';
      lnRetVal := iapiAuditTrail.GetMessage( lsSignWhatId,
                                             :NEW.section,
                                             :NEW.parameter,
                                             NULL,
                                             NULL,
                                             NULL,
                                             lsSignWhat );
   END IF;

   IF     :NEW.PARAMETER_DATA = '0'
      AND :NEW.PARAMETER = 'locking_enabled'
   THEN
      /** Unlock all specifications when locking_enabled is false **/
      UPDATE SPECIFICATION_SECTION
         SET LOCKED = NULL;

      UPDATE SPECIFICATION_HEADER
         SET LOCKED = NULL;
   END IF;

   INSERT INTO interspc_cfg_h
               ( section,
                 parameter,
                 parameter_data_old,
                 parameter_data_new,
                 action,
                 es_seq_no,
                 user_id,
                 forename,
                 last_name,
                 TIMESTAMP,
                 sign_for_id,
                 sign_for,
                 sign_what_id,
                 sign_what )
        VALUES ( :NEW.section,
                 :NEW.parameter,
                 :OLD.parameter_data,
                 :NEW.parameter_data,
                 'U',
                 :NEW.es_seq_no,
                 lsUser,
                 lsForeName,
                 lsLastName,
                 ldTimeStamp,
                 lsSignForId,
                 lsSignFor,
                 lsSignWhatId,
                 lsSignWhat );
EXCEPTION
   WHEN OTHERS
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            SQLERRM );
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
END;
/
ALTER TRIGGER "INTERSPC"."TR_INTERSPC_CFG_AU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITALLERGENSYNONYMTYPE_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITALLERGENSYNONYMTYPE_OD" 
   BEFORE DELETE
   ON ITALLERGENSYNONYMTYPE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_ITALLERGENSYNONYMTYPE_OD';
   lnRetVal                      iapiType.ErrorNum_Type;
   l_allow                       interspc_cfg.parameter_data%TYPE;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;


      INSERT INTO ITALLERGENSYNONYMTYPE_H
                  ( allergen,
                    synonymtype,
                    intl,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :OLD.allergen,
                    :OLD.synonymtype,
                    :OLD.intl,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D' );

END;
/
ALTER TRIGGER "INTERSPC"."TR_ITALLERGENSYNONYMTYPE_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITALLERGENSYNONYMTYPE_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITALLERGENSYNONYMTYPE_OI" 
   BEFORE INSERT
   ON ITALLERGENSYNONYMTYPE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_ITALLERGENSYNONYMTYPE_OI';
   lnRetVal                      iapiType.ErrorNum_Type;
   lsAllowIngredients            VARCHAR2( 1 );
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

      INSERT INTO ITALLERGENSYNONYMTYPE_H
                  ( allergen,
                    synonymtype,
                    intl,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :NEW.allergen,
                    :NEW.synonymtype,
                    :NEW.intl,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I' );

END;
/
ALTER TRIGGER "INTERSPC"."TR_ITALLERGENSYNONYMTYPE_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITALLERGENSYNONYMTYPE_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITALLERGENSYNONYMTYPE_OU" 
   BEFORE UPDATE
   ON ITALLERGENSYNONYMTYPE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow                       interspc_cfg.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'TR_ITALLERGENSYNONYMTYPE_OU';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

      INSERT INTO ITALLERGENSYNONYMTYPE_H
                  ( allergen,
                    synonymtype,
                    intl,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :NEW.allergen,
                    :NEW.synonymtype,
                    :NEW.intl,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U' );
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITALLERGENSYNONYMTYPE_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITCLAT_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITCLAT_OD" BEFORE DELETE ON ITCLAT REFERENCING OLD AS OLD NEW AS NEW
BEGIN
UPDATE interspc_cfg
SET parameter_data = to_char(SYSDATE,'DD/MM/YYYY HH24:MI:SS')
WHERE parameter = 'last_modified_on'
AND section = 'Classification';
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITCLAT_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITCLAT_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITCLAT_OI" BEFORE INSERT ON ITCLAT REFERENCING OLD AS OLD NEW AS NEW
BEGIN
UPDATE interspc_cfg
SET parameter_data = to_char(SYSDATE,'DD/MM/YYYY HH24:MI:SS')
WHERE parameter = 'last_modified_on'
AND section = 'Classification';
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITCLAT_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITCLAT_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITCLAT_OU" AFTER UPDATE ON ITCLAT REFERENCING OLD AS OLD NEW AS NEW
BEGIN
UPDATE interspc_cfg
SET parameter_data = to_char(SYSDATE,'DD/MM/YYYY HH24:MI:SS')
WHERE parameter = 'last_modified_on'
AND section = 'Classification';
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITCLAT_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITCLCLF_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITCLCLF_OD" BEFORE DELETE ON ITCLCLF REFERENCING OLD AS OLD NEW AS NEW
BEGIN
UPDATE interspc_cfg
SET parameter_data = to_char(SYSDATE,'DD/MM/YYYY HH24:MI:SS')
WHERE parameter = 'last_modified_on'
AND section = 'Classification';
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITCLCLF_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITCLCLF_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITCLCLF_OI" BEFORE INSERT ON ITCLCLF REFERENCING OLD AS OLD NEW AS NEW
BEGIN
UPDATE interspc_cfg
SET parameter_data = to_char(SYSDATE,'DD/MM/YYYY HH24:MI:SS')
WHERE parameter = 'last_modified_on'
AND section = 'Classification';
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITCLCLF_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITCLCLF_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITCLCLF_OU" AFTER UPDATE ON ITCLCLF REFERENCING OLD AS OLD NEW AS NEW
BEGIN
UPDATE interspc_cfg
SET parameter_data = to_char(SYSDATE,'DD/MM/YYYY HH24:MI:SS')
WHERE parameter = 'last_modified_on'
AND section = 'Classification';
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITCLCLF_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITCLD_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITCLD_OD" BEFORE DELETE ON ITCLD REFERENCING OLD AS OLD NEW AS NEW
BEGIN
UPDATE interspc_cfg
SET parameter_data = to_char(SYSDATE,'DD/MM/YYYY HH24:MI:SS')
WHERE parameter = 'last_modified_on'
AND section = 'Classification';
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITCLD_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITCLD_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITCLD_OI" BEFORE INSERT ON ITCLD REFERENCING OLD AS OLD NEW AS NEW
BEGIN
UPDATE interspc_cfg
SET parameter_data = to_char(SYSDATE,'DD/MM/YYYY HH24:MI:SS')
WHERE parameter = 'last_modified_on'
AND section = 'Classification';
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITCLD_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITCLD_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITCLD_OU" AFTER UPDATE ON ITCLD REFERENCING OLD AS OLD NEW AS NEW
BEGIN
UPDATE interspc_cfg
SET parameter_data = to_char(SYSDATE,'DD/MM/YYYY HH24:MI:SS')
WHERE parameter = 'last_modified_on'
AND section = 'Classification';
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITCLD_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITCLTV_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITCLTV_OD" BEFORE DELETE ON ITCLTV REFERENCING OLD AS OLD NEW AS NEW
BEGIN
UPDATE interspc_cfg
SET parameter_data = to_char(SYSDATE,'DD/MM/YYYY HH24:MI:SS')
WHERE parameter = 'last_modified_on'
AND section = 'Classification';
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITCLTV_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITCLTV_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITCLTV_OI" BEFORE INSERT ON ITCLTV REFERENCING OLD AS OLD NEW AS NEW
BEGIN
UPDATE interspc_cfg
SET parameter_data = to_char(SYSDATE,'DD/MM/YYYY HH24:MI:SS')
WHERE parameter = 'last_modified_on'
AND section = 'Classification';
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITCLTV_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITCLTV_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITCLTV_OU" AFTER UPDATE ON ITCLTV REFERENCING OLD AS OLD NEW AS NEW
BEGIN
UPDATE interspc_cfg
SET parameter_data = to_char(SYSDATE,'DD/MM/YYYY HH24:MI:SS')
WHERE parameter = 'last_modified_on'
AND section = 'Classification';
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITCLTV_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITCUSTOMCALCULATION_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITCUSTOMCALCULATION_OI" 
   BEFORE INSERT
   ON ITCUSTOMCALCULATION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorTextAndLoginfo( 'TR_ITCUSTOMCALCULATION_OI',
                                                      '',
                                                      iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ITCUSTOMCALCULATION_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN

      UPDATE itcustomcalculation_h
         SET max_rev = 0
       WHERE customcalculation_id = :NEW.customcalculation_id;


	  INSERT INTO itcustomcalculation_h
                  ( customcalculation_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.customcalculation_id,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );


   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITCUSTOMCALCULATION_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITERROR
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITERROR" 
   AFTER INSERT ON ITERROR
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW

 BEGIN
  DBMS_ALERT.SIGNAL('NEW_ERROR', :new.USER_ID) ;
END ;

/
ALTER TRIGGER "INTERSPC"."TR_ITERROR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIM_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIM_OI" 
   BEFORE INSERT
   ON ITFOODCLAIM
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lsSource                      iapiType.Source_Type := 'Tr_ItFoodClaim_Oi';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE itfoodclaim_h
         SET max_rev = 0
       WHERE food_claim_id = :NEW.food_claim_id;

      INSERT INTO itfoodclaim_H
                  ( food_claim_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_id,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIM_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIM_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIM_OU" 
   AFTER UPDATE OF DESCRIPTION
   ON ITFOODCLAIM
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ITFOODCLAIM_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND ( NVL( :OLD.description,
                 ' ' ) <> NVL( :NEW.description,
                               ' ' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM itfoodclaim_h
       WHERE food_claim_id = :NEW.food_claim_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE itfoodclaim_h
         SET max_rev = 0
       WHERE food_claim_id = :NEW.food_claim_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM itfoodclaim_H
       WHERE food_claim_id = :NEW.food_claim_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITFOODCLAIM_H
                  ( food_claim_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_id,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO ITFOODCLAIM_H
                  ( food_claim_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.food_claim_id,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                --IS190 --max_rev --orig
                1
           FROM itfoodclaim_h
          WHERE food_claim_id = :NEW.food_claim_id
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIM_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMALERT_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMALERT_OI" 
   BEFORE INSERT
   ON ITFOODCLAIMALERT
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lsSource                      iapiType.Source_Type := 'Tr_ItFoodClaimAlert_Oi';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE itfoodclaimalert_h
         SET max_rev = 0
       WHERE food_claim_alert_id = :NEW.food_claim_alert_id;

      INSERT INTO itfoodclaimalert_H
                  ( food_claim_alert_id,
                    revision,
                    lang_id,
                    description,
					long_description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_alert_id,
                    100,
                    1,
                    :NEW.description,
					:NEW.long_description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMALERT_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMALERT_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMALERT_OU" 
   AFTER UPDATE
   ON ITFOODCLAIMALERT
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ITFOODCLAIMALERT_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND (     (NVL( :OLD.description, ' ' ) <> NVL( :NEW.description, ' ' ) )
	  	  	OR	(NVL( :OLD.long_description, ' ' ) <> NVL( :NEW.long_description, ' ' ) ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM itfoodclaimalert_h
       WHERE food_claim_alert_id = :NEW.food_claim_alert_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE itfoodclaimalert_h
         SET max_rev = 0
       WHERE food_claim_alert_id = :NEW.food_claim_alert_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM itfoodclaimalert_H
       WHERE food_claim_alert_id = :NEW.food_claim_alert_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITFOODCLAIMALERT_H
                  ( food_claim_alert_id,
                    revision,
                    lang_id,
                    description,
					long_description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_alert_id,
                    l_next_val,
                    1,
                    :NEW.description,
					:NEW.long_description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO ITFOODCLAIMALERT_H
                  ( food_claim_alert_id,
                    revision,
                    lang_id,
                    description,
					long_description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.food_claim_alert_id,
                l_next_val,
                lang_id,
                description,
				long_description,
                last_modified_on,
                last_modified_by,
                --IS190 --max_rev --orig
                1
           FROM itfoodclaimalert_h
          WHERE food_claim_alert_id = :NEW.food_claim_alert_id
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMALERT_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMCD_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMCD_OI" 
   BEFORE INSERT
   ON ITFOODCLAIMCD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lsSource                      iapiType.Source_Type := 'Tr_ItFoodClaimCd_Oi';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE itfoodclaimcd_h
         SET max_rev = 0
       WHERE food_claim_cd_id = :NEW.food_claim_cd_id;

      INSERT INTO itfoodclaimcd_H
                  ( food_claim_cd_id,
                    revision,
                    lang_id,
                    description,
					long_description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_cd_id,
                    100,
                    1,
                    :NEW.description,
					:NEW.long_description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMCD_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMCD_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMCD_OU" 
   AFTER UPDATE
   ON ITFOODCLAIMCD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ITFOODCLAIMCD_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND (     (NVL( :OLD.description, ' ' ) <> NVL( :NEW.description, ' ' ) )
	  	  	OR	(NVL( :OLD.long_description, ' ' ) <> NVL( :NEW.long_description, ' ' ) ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM itfoodclaimcd_h
       WHERE food_claim_cd_id = :NEW.food_claim_cd_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE itfoodclaimcd_h
         SET max_rev = 0
       WHERE food_claim_cd_id = :NEW.food_claim_cd_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM itfoodclaimcd_H
       WHERE food_claim_cd_id = :NEW.food_claim_cd_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITFOODCLAIMCD_H
                  ( food_claim_cd_id,
                    revision,
                    lang_id,
                    description,
					long_description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_cd_id,
                    l_next_val,
                    1,
                    :NEW.description,
					:NEW.long_description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO ITFOODCLAIMCD_H
                  ( food_claim_cd_id,
                    revision,
                    lang_id,
                    description,
					long_description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.food_claim_cd_id,
                l_next_val,
                lang_id,
                description,
				long_description,
                last_modified_on,
                last_modified_by,
                --IS190 --max_rev --orig
                1
           FROM itfoodclaimcd_h
          WHERE food_claim_cd_id = :NEW.food_claim_cd_id
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMCD_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMCRIT_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRIT_OI" 
   BEFORE INSERT
   ON ITFOODCLAIMCRIT
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lsSource                      iapiType.Source_Type := 'Tr_ItFoodClaimcrit_Oi';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE itfoodclaimcrit_h
         SET max_rev = 0
       WHERE food_claim_crit_id = :NEW.food_claim_crit_id;

      INSERT INTO itfoodclaimcrit_H
                  ( food_claim_crit_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_crit_id,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRIT_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMCRIT_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRIT_OU" 
   AFTER UPDATE OF DESCRIPTION
   ON ITFOODCLAIMCRIT
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ITFOODCLAIMCRIT_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND ( NVL( :OLD.description,
                 ' ' ) <> NVL( :NEW.description,
                               ' ' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM itfoodclaimcrit_h
       WHERE food_claim_crit_id = :NEW.food_claim_crit_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE itfoodclaimcrit_h
         SET max_rev = 0
       WHERE food_claim_crit_id = :NEW.food_claim_crit_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM itfoodclaimcrit_H
       WHERE food_claim_crit_id = :NEW.food_claim_crit_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITFOODCLAIMCRIT_H
                  ( food_claim_crit_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_crit_id,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO ITFOODCLAIMCRIT_H
                  ( food_claim_crit_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.food_claim_crit_id,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                --IS190 --max_rev --orig
                1
           FROM itfoodclaimcrit_h
          WHERE food_claim_crit_id = :NEW.food_claim_crit_id
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRIT_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMCRITKEY_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRITKEY_OI" 
   BEFORE INSERT
   ON ITFOODCLAIMCRITKEY
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lsSource                      iapiType.Source_Type := 'Tr_ItFoodClaimcritkey_Oi';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE itfoodclaimcritkey_h
         SET max_rev = 0
       WHERE food_claim_crit_key_id = :NEW.food_claim_crit_key_id;

      INSERT INTO itfoodclaimcritkey_H
                  ( food_claim_crit_key_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_crit_key_id,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRITKEY_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMCRITKEY_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRITKEY_OU" 
   AFTER UPDATE OF DESCRIPTION
   ON ITFOODCLAIMCRITKEY
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ITFOODCLAIMCRITKEY_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND (    NVL( :OLD.description, ' ' ) <> NVL( :NEW.description, ' ' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM itfoodclaimcritkey_h
       WHERE food_claim_crit_key_id = :NEW.food_claim_crit_key_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE itfoodclaimcritkey_h
         SET max_rev = 0
       WHERE food_claim_crit_key_id = :NEW.food_claim_crit_key_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM itfoodclaimcritkey_H
       WHERE food_claim_crit_key_id = :NEW.food_claim_crit_key_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITFOODCLAIMCRITKEY_H
                  ( food_claim_crit_key_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_crit_key_id,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO ITFOODCLAIMCRITKEY_H
                  ( food_claim_crit_key_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.food_claim_crit_key_id,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                --IS190 --max_rev --orig
                1
           FROM itfoodclaimcritkey_h
          WHERE food_claim_crit_key_id = :NEW.food_claim_crit_key_id
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRITKEY_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMCRITKEYCD_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRITKEYCD_OI" 
   BEFORE INSERT
   ON ITFOODCLAIMCRITKEYCD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lsSource                      iapiType.Source_Type := 'Tr_ItFoodClaimcritkeycd_Oi';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE itfoodclaimcritkeycd_h
         SET max_rev = 0
       WHERE food_claim_crit_key_cd_id = :NEW.food_claim_crit_key_cd_id;

      INSERT INTO itfoodclaimcritkeycd_H
                  ( food_claim_crit_key_cd_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_crit_key_cd_id,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRITKEYCD_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMCRITKEYCD_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRITKEYCD_OU" 
   AFTER UPDATE OF DESCRIPTION
   ON ITFOODCLAIMCRITKEYCD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ITFOODCLAIMCRITKEYCD_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND (    NVL( :OLD.description, ' ' ) <> NVL( :NEW.description, ' ' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM itfoodclaimcritkeycd_h
       WHERE food_claim_crit_key_cd_id = :NEW.food_claim_crit_key_cd_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE itfoodclaimcritkeycd_h
         SET max_rev = 0
       WHERE food_claim_crit_key_cd_id = :NEW.food_claim_crit_key_cd_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM itfoodclaimcritkeycd_H
       WHERE food_claim_crit_key_cd_id = :NEW.food_claim_crit_key_cd_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITFOODCLAIMCRITKEYCD_H
                  ( food_claim_crit_key_cd_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_crit_key_cd_id,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO ITFOODCLAIMCRITKEYCD_H
                  ( food_claim_crit_key_cd_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.food_claim_crit_key_cd_id,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                --IS190 --max_rev --orig
                1
           FROM itfoodclaimcritkeycd_h
          WHERE food_claim_crit_key_cd_id = :NEW.food_claim_crit_key_cd_id
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRITKEYCD_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMCRITRULE_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRITRULE_OI" 
   BEFORE INSERT
   ON ITFOODCLAIMCRITRULE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lsSource                      iapiType.Source_Type := 'Tr_ItFoodClaimcritrule_Oi';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE itfoodclaimcritrule_h
         SET max_rev = 0
       WHERE food_claim_crit_rule_id = :NEW.food_claim_crit_rule_id;

      INSERT INTO itfoodclaimcritrule_H
                  ( food_claim_crit_rule_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_crit_rule_id,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRITRULE_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMCRITRULE_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRITRULE_OU" 
   AFTER UPDATE OF DESCRIPTION
   ON ITFOODCLAIMCRITRULE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ITFOODCLAIMCRITRULE_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND (    NVL( :OLD.description, ' ' ) <> NVL( :NEW.description, ' ' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM itfoodclaimcritrule_h
       WHERE food_claim_crit_rule_id = :NEW.food_claim_crit_rule_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE itfoodclaimcritrule_h
         SET max_rev = 0
       WHERE food_claim_crit_rule_id = :NEW.food_claim_crit_rule_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM itfoodclaimcritrule_H
       WHERE food_claim_crit_rule_id = :NEW.food_claim_crit_rule_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITFOODCLAIMCRITRULE_H
                  ( food_claim_crit_rule_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_crit_rule_id,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO ITFOODCLAIMCRITRULE_H
                  ( food_claim_crit_rule_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.food_claim_crit_rule_id,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                --IS190 --max_rev --orig
                1
           FROM itfoodclaimcritrule_h
          WHERE food_claim_crit_rule_id = :NEW.food_claim_crit_rule_id
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRITRULE_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMCRITRULECD_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRITRULECD_OI" 
   BEFORE INSERT
   ON ITFOODCLAIMCRITRULECD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lsSource                      iapiType.Source_Type := 'Tr_ItFoodClaimcritrulecd_Oi';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE itfoodclaimcritrulecd_h
         SET max_rev = 0
       WHERE food_claim_crit_rule_cd_id = :NEW.food_claim_crit_rule_cd_id;

      INSERT INTO itfoodclaimcritrulecd_H
                  ( food_claim_crit_rule_cd_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_crit_rule_cd_id,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRITRULECD_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMCRITRULECD_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRITRULECD_OU" 
   AFTER UPDATE OF DESCRIPTION
   ON ITFOODCLAIMCRITRULECD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ITFOODCLAIMCRITRULECD_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND (    NVL( :OLD.description, ' ' ) <> NVL( :NEW.description, ' ' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM itfoodclaimcritrulecd_h
       WHERE food_claim_crit_rule_cd_id = :NEW.food_claim_crit_rule_cd_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE itfoodclaimcritrulecd_h
         SET max_rev = 0
       WHERE food_claim_crit_rule_cd_id = :NEW.food_claim_crit_rule_cd_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM itfoodclaimcritrulecd_H
       WHERE food_claim_crit_rule_cd_id = :NEW.food_claim_crit_rule_cd_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITFOODCLAIMCRITRULECD_H
                  ( food_claim_crit_rule_cd_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_crit_rule_cd_id,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO ITFOODCLAIMCRITRULECD_H
                  ( food_claim_crit_rule_cd_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.food_claim_crit_rule_cd_id,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                --IS190 --max_rev --orig
                1
           FROM itfoodclaimcritrulecd_h
          WHERE food_claim_crit_rule_cd_id = :NEW.food_claim_crit_rule_cd_id
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMCRITRULECD_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMLABEL_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMLABEL_OI" 
   BEFORE INSERT
   ON ITFOODCLAIMLABEL
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lsSource                      iapiType.Source_Type := 'Tr_ItFoodClaimLabel_Oi';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE itfoodclaimlabel_h
         SET max_rev = 0
       WHERE food_claim_label_id = :NEW.food_claim_label_id;

      INSERT INTO itfoodclaimlabel_H
                  ( food_claim_label_id,
                    revision,
                    lang_id,
                    description,
					long_description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_label_id,
                    100,
                    1,
                    :NEW.description,
					:NEW.long_description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMLABEL_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMLABEL_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMLABEL_OU" 
   AFTER UPDATE
   ON ITFOODCLAIMLABEL
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ITFOODCLAIMLABEL_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND (     (NVL( :OLD.description, ' ' ) <> NVL( :NEW.description, ' ' ) )
	  	  	OR	(NVL( :OLD.long_description, ' ' ) <> NVL( :NEW.long_description, ' ' ) ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM itfoodclaimlabel_h
       WHERE food_claim_label_id = :NEW.food_claim_label_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE itfoodclaimlabel_h
         SET max_rev = 0
       WHERE food_claim_label_id = :NEW.food_claim_label_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM itfoodclaimlabel_H
       WHERE food_claim_label_id = :NEW.food_claim_label_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITFOODCLAIMLABEL_H
                  ( food_claim_label_id,
                    revision,
                    lang_id,
                    description,
					long_description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_label_id,
                    l_next_val,
                    1,
                    :NEW.description,
					:NEW.long_description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO ITFOODCLAIMLABEL_H
                  ( food_claim_label_id,
                    revision,
                    lang_id,
                    description,
					long_description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.food_claim_label_id,
                l_next_val,
                lang_id,
                description,
				long_description,
                last_modified_on,
                last_modified_by,
                --IS190 --max_rev --orig
                1
           FROM itfoodclaimlabel_h
          WHERE food_claim_label_id = :NEW.food_claim_label_id
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMLABEL_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMNOTE_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMNOTE_OI" 
   BEFORE INSERT
   ON ITFOODCLAIMNOTE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lsSource                      iapiType.Source_Type := 'Tr_ItFoodClaimNote_Oi';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE itfoodclaimnote_h
         SET max_rev = 0
       WHERE food_claim_note_id = :NEW.food_claim_note_id;

      INSERT INTO itfoodclaimnote_H
                  ( food_claim_note_id,
                    revision,
                    lang_id,
                    description,
					long_description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_note_id,
                    100,
                    1,
                    :NEW.description,
					:NEW.long_description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMNOTE_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMNOTE_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMNOTE_OU" 
   AFTER UPDATE
   ON ITFOODCLAIMNOTE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ITFOODCLAIMNOTE_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND (     (NVL( :OLD.description, ' ' ) <> NVL( :NEW.description, ' ' ) )
	  	  	OR	(NVL( :OLD.long_description, ' ' ) <> NVL( :NEW.long_description, ' ' ) ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM itfoodclaimnote_h
       WHERE food_claim_note_id = :NEW.food_claim_note_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE itfoodclaimnote_h
         SET max_rev = 0
       WHERE food_claim_note_id = :NEW.food_claim_note_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM itfoodclaimnote_H
       WHERE food_claim_note_id = :NEW.food_claim_note_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITFOODCLAIMNOTE_H
                  ( food_claim_note_id,
                    revision,
                    lang_id,
                    description,
					long_description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_note_id,
                    l_next_val,
                    1,
                    :NEW.description,
					:NEW.long_description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO ITFOODCLAIMNOTE_H
                  ( food_claim_note_id,
                    revision,
                    lang_id,
                    description,
					long_description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.food_claim_note_id,
                l_next_val,
                lang_id,
                description,
				long_description,
                last_modified_on,
                last_modified_by,
                --IS190 --max_rev --orig
                1
           FROM itfoodclaimnote_h
          WHERE food_claim_note_id = :NEW.food_claim_note_id
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMNOTE_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMSYN_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMSYN_OI" 
   BEFORE INSERT
   ON ITFOODCLAIMSYN
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lsSource                      iapiType.Source_Type := 'Tr_ItFoodClaimSyn_Oi';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE itfoodclaimsyn_h
         SET max_rev = 0
       WHERE food_claim_syn_id = :NEW.food_claim_syn_id;

      INSERT INTO itfoodclaimsyn_H
                  ( food_claim_syn_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_syn_id,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMSYN_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODCLAIMSYN_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODCLAIMSYN_OU" 
   AFTER UPDATE OF DESCRIPTION
   ON ITFOODCLAIMSYN
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ITFOODCLAIMSYN_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND (    NVL( :OLD.description, ' ' ) <> NVL( :NEW.description, ' ' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM itfoodclaimsyn_h
       WHERE food_claim_syn_id = :NEW.food_claim_syn_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE itfoodclaimsyn_h
         SET max_rev = 0
       WHERE food_claim_syn_id = :NEW.food_claim_syn_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM itfoodclaimsyn_H
       WHERE food_claim_syn_id = :NEW.food_claim_syn_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITFOODCLAIMSYN_H
                  ( food_claim_syn_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_claim_syn_id,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO ITFOODCLAIMSYN_H
                  ( food_claim_syn_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.food_claim_syn_id,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                --IS190 --max_rev --orig
                1
           FROM itfoodclaimsyn_h
          WHERE food_claim_syn_id = :NEW.food_claim_syn_id
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODCLAIMSYN_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODTYPE_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODTYPE_OI" 
   BEFORE INSERT
   ON ITFOODTYPE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lsSource                      iapiType.Source_Type := 'Tr_ItFoodType_Oi';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE itfoodtype_h
         SET max_rev = 0
       WHERE food_type_id = :NEW.food_type_id;

      INSERT INTO itfoodtype_H
                  ( food_type_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_type_id,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODTYPE_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFOODTYPE_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFOODTYPE_OU" 
   AFTER UPDATE OF DESCRIPTION
   ON ITFOODTYPE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ITFOODTYPE_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND (    NVL( :OLD.description, ' ' ) <> NVL( :NEW.description, ' ' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM itfoodtype_h
       WHERE food_type_id = :NEW.food_type_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE itfoodtype_h
         SET max_rev = 0
       WHERE food_type_id = :NEW.food_type_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM itfoodtype_H
       WHERE food_type_id = :NEW.food_type_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITFOODTYPE_H
                  ( food_type_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.food_type_id,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO ITFOODTYPE_H
                  ( food_type_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.food_type_id,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                max_rev
           FROM itfoodtype_h
          WHERE food_type_id = :NEW.food_type_id
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFOODTYPE_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITFRMV_BI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITFRMV_BI" BEFORE INSERT ON ITFRMV REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

BEGIN
	UPDATE ITFRMVAL
	SET MASK_ID = :new.view_id
	WHERE frame_no = :new.frame_no
	AND revision = :new.revision
	AND owner = :new.owner
	AND mask_id = -1;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITFRMV_BI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGCFG_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGCFG_OI" 
   BEFORE INSERT
   ON ITINGCFG
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Itingcfg_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
   lsAllowIngredients            VARCHAR2( 1 );
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO lsAllowIngredients
     FROM interspc_cfg
    WHERE section = 'interspec'
      AND parameter = 'allow_ingdet';

   IF     lsAllowIngredients = '1'
      AND (     ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' )
            OR (     :NEW.intl = '0'
                 AND (    iapiGeneral.SESSION.DATABASE.DatabaseType = 'R'
                       OR iapiGeneral.SESSION.DATABASE.DatabaseType = 'L' ) ) )
   THEN
      UPDATE itingcfg_h
         SET max_rev = 0
       WHERE pid = :NEW.pid
         AND cid = :NEW.cid;

      INSERT INTO itingcfg_h
                  ( pid,
                    cid,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.pid,
                    :NEW.cid,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGCFG_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGCFG_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGCFG_OU" 
   AFTER UPDATE OF description, status, cid_type, ing_type, max_pct
   ON ITINGCFG
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_revision                    NUMBER;
   l_next_val                    NUMBER;
   l_allow_ingdet                interspc_cfg.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Itingcfg_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow_ingdet
     FROM interspc_cfg
    WHERE parameter = 'allow_ingdet'
      AND SECTION = 'interspec';

   IF     l_allow_ingdet = 1
      AND ( :OLD.description <> :NEW.description )
   THEN
      SELECT revision
        INTO l_revision
        FROM itingcfg_h
       WHERE pid = :NEW.pid
         AND cid = :NEW.cid
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE itingcfg_h
         SET max_rev = 0
       WHERE pid = :NEW.pid
         AND cid = :NEW.cid
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM itingcfg_h
       WHERE pid = :NEW.pid
         AND cid = :NEW.cid;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO itingcfg_h
                  ( pid,
                    cid,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.pid,
                    :NEW.cid,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO itingcfg_h
                  ( pid,
                    cid,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.pid,
                :NEW.cid,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                1
           FROM itingcfg_h
          WHERE pid = :NEW.pid
            AND cid = :NEW.cid
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;

   IF     l_allow_ingdet = 1
      AND :OLD.status <> :NEW.status
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'ic',
                    :NEW.cid,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;

   IF     l_allow_ingdet = 1
      AND :OLD.ing_type <> :NEW.ing_type
   THEN
      UPDATE itingcfg_h
         SET last_modified_by = iapiGeneral.SESSION.ApplicationUser.UserId,
             last_modified_on = SYSDATE
       WHERE pid = :NEW.pid
         AND cid = :NEW.cid;
   END IF;

   IF     l_allow_ingdet = 1
      AND :OLD.cid_type <> :NEW.cid_type
   THEN
      UPDATE itingcfg_h
         SET last_modified_by = iapiGeneral.SESSION.ApplicationUser.UserId,
             last_modified_on = SYSDATE
       WHERE pid = :NEW.pid
         AND cid = :NEW.cid;
   END IF;

   IF     l_allow_ingdet = 1
      AND NVL( :OLD.max_pct,
               -1 ) <> NVL( :NEW.max_pct,
                            -1 )
   THEN
      UPDATE itingcfg_h
         SET last_modified_by = iapiGeneral.SESSION.ApplicationUser.UserId,
             last_modified_on = SYSDATE
       WHERE pid = :NEW.pid
         AND cid = :NEW.cid;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGCFG_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGCFGSYNONYMTYPE_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGCFGSYNONYMTYPE_OD" 
   BEFORE DELETE
   ON ITINGCFGSYNONYMTYPE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_ITINGCFGSYNONYMTYPE_OD';
   lnRetVal                      iapiType.ErrorNum_Type;
   l_allow                       interspc_cfg.parameter_data%TYPE;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;


      INSERT INTO ITINGCFGSYNONYMTYPE_h
                  ( pid,
                    cid,
                    show_allergen,
                    highlight_allergen,
					contains_allergen,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :OLD.pid,
                    :OLD.cid,
                    :OLD.show_allergen,
                    :OLD.highlight_allergen,
                    :OLD.contains_allergen,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D' );

END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGCFGSYNONYMTYPE_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGCFGSYNONYMTYPE_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGCFGSYNONYMTYPE_OI" 
   BEFORE INSERT
   ON ITINGCFGSYNONYMTYPE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_ITINGCFGSYNONYMTYPE_OI';
   lnRetVal                      iapiType.ErrorNum_Type;
   lsAllowIngredients            VARCHAR2( 1 );
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

      INSERT INTO ITINGCFGSYNONYMTYPE_H
                  ( pid,
                    cid,
                    show_allergen,
                    highlight_allergen,
					contains_allergen,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :NEW.pid,
                    :NEW.cid,
                    :NEW.show_allergen,
                    :NEW.highlight_allergen,
                    :NEW.contains_allergen,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I' );

END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGCFGSYNONYMTYPE_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGCFGSYNONYMTYPE_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGCFGSYNONYMTYPE_OU" 
   BEFORE UPDATE
   ON ITINGCFGSYNONYMTYPE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow                       interspc_cfg.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'TR_ITINGCFGSYNONYMTYPE_OU';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

      INSERT INTO ITINGCFGSYNONYMTYPE_H
                  ( pid,
                    cid,
                    show_allergen,
                    highlight_allergen,
					contains_allergen,
                    last_modified_on,
                    last_modified_by,
                    action )
           VALUES ( :NEW.pid,
                    :NEW.cid,
                    :NEW.show_allergen,
                    :NEW.highlight_allergen,
                    :NEW.contains_allergen,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U' );
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGCFGSYNONYMTYPE_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGCTFA_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGCTFA_OD" 
   BEFORE DELETE
   ON ITINGCTFA
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Itingctfa_Od';
   lnRetVal                      iapiType.ErrorNum_Type;
   l_allow                       interspc_cfg.parameter_data%TYPE;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow
     FROM interspc_cfg
    WHERE section = 'interspec'
      AND parameter = 'allow_ingdet';

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND l_allow = '1'
   THEN
      INSERT INTO itingctfa_h
                  ( ingredient,
                    reg_id,
                    start_pg,
                    end_pg,
                    list_ind,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :OLD.ingredient,
                    :OLD.reg_id,
                    :OLD.start_pg,
                    :OLD.end_pg,
                    :OLD.list_ind,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    :OLD.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGCTFA_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGCTFA_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGCTFA_OI" 
   BEFORE INSERT
   ON ITINGCTFA
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow                       interspc_cfg.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Itingctfa_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow
     FROM interspc_cfg
    WHERE section = 'interspec'
      AND parameter = 'allow_ingdet';

   IF     l_allow = '1'
      AND (     ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' )
            OR (     :NEW.intl = '0'
                 AND (    iapiGeneral.SESSION.DATABASE.DatabaseType = 'R'
                       OR iapiGeneral.SESSION.DATABASE.DatabaseType = 'L' ) ) )
   THEN
      INSERT INTO itingctfa_h
                  ( ingredient,
                    reg_id,
                    start_pg,
                    end_pg,
                    list_ind,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.ingredient,
                    :NEW.reg_id,
                    :NEW.start_pg,
                    :NEW.end_pg,
                    :NEW.list_ind,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGCTFA_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGCTFA_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGCTFA_OU" 
   BEFORE UPDATE
   ON ITINGCTFA
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow                       interspc_cfg.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Itingctfa_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow
     FROM interspc_cfg
    WHERE section = 'interspec'
      AND parameter = 'allow_ingdet';

   IF     l_allow = '1'
      AND (     ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' )
            OR (     :NEW.intl = '0'
                 AND (    iapiGeneral.SESSION.DATABASE.DatabaseType = 'R'
                       OR iapiGeneral.SESSION.DATABASE.DatabaseType = 'L' ) ) )
   THEN
      INSERT INTO itingctfa_h
                  ( ingredient,
                    reg_id,
                    start_pg,
                    end_pg,
                    list_ind,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.ingredient,
                    :NEW.reg_id,
                    :NEW.start_pg,
                    :NEW.end_pg,
                    :NEW.list_ind,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGCTFA_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGD_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGD_OD" 
   BEFORE DELETE
   ON ITINGD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow                       INTERSPC_CFG.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Itingd_Od';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow
     FROM INTERSPC_CFG
    WHERE SECTION = 'interspec'
      AND parameter = 'allow_ingdet';

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND l_allow = '1'
   THEN
      INSERT INTO ITINGD_H
                  ( ingredient,
                    pid,
                    cid,
                    last_modified_on,
                    last_modified_by,
                    action,
                    pref,
                    intl )
           VALUES ( :OLD.ingredient,
                    :OLD.pid,
                    :OLD.cid,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    :OLD.pref,
                    :OLD.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGD_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGD_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGD_OI" 
   BEFORE INSERT
   ON ITINGD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow                       interspc_cfg.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Itingd_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow
     FROM interspc_cfg
    WHERE section = 'interspec'
      AND parameter = 'allow_ingdet';

   IF     l_allow = '1'
      AND (     ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' )
            OR (     :NEW.intl = '0'
                 AND (    iapiGeneral.SESSION.DATABASE.DatabaseType = 'R'
                       OR iapiGeneral.SESSION.DATABASE.DatabaseType = 'L' ) ) )
   THEN
      INSERT INTO itingd_h
                  ( ingredient,
                    pid,
                    cid,
                    last_modified_on,
                    last_modified_by,
                    action,
                    pref,
                    intl )
           VALUES ( :NEW.ingredient,
                    :NEW.pid,
                    :NEW.cid,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.pref,
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGD_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGD_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGD_OU" 
   BEFORE UPDATE
   ON ITINGD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow                       interspc_cfg.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Itingd_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow
     FROM interspc_cfg
    WHERE section = 'interspec'
      AND parameter = 'allow_ingdet';

   IF     l_allow = '1'
      AND (     ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' )
            OR (     :NEW.intl = '0'
                 AND (    iapiGeneral.SESSION.DATABASE.DatabaseType = 'R'
                       OR iapiGeneral.SESSION.DATABASE.DatabaseType = 'L' ) ) )
   THEN
      INSERT INTO itingd_h
                  ( ingredient,
                    pid,
                    cid,
                    last_modified_on,
                    last_modified_by,
                    action,
                    pref,
                    intl )
           VALUES ( :NEW.ingredient,
                    :NEW.pid,
                    :NEW.cid,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.pref,
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGD_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGDETAILCONFIG_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGDETAILCONFIG_OI" 
   BEFORE INSERT
   ON ITINGDETAILCONFIG
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lsSource                      iapiType.Source_Type := 'TR_ITINGDETAILCONFIG_OI';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  --AND :NEW.intl = '0'
                  )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE ITINGDETAILCONFIG_H
         SET max_rev = 0
       WHERE ingdetail_type = :NEW.ingdetail_type;

      INSERT INTO ITINGDETAILCONFIG_H
                  ( ingdetail_type,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.ingdetail_type,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGDETAILCONFIG_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGDETAILCONFIG_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGDETAILCONFIG_OU" 
   AFTER UPDATE OF description, status
   ON ITINGDETAILCONFIG
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ITINGDETAILCONFIG_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  --AND :NEW.intl = '0'
                  )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND (    :OLD.description <> :NEW.description)
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM ITINGDETAILCONFIG_h
       WHERE ingdetail_type = :NEW.ingdetail_type
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE ITINGDETAILCONFIG_h
         SET max_rev = 0
       WHERE ingdetail_type = :NEW.ingdetail_type
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM ITINGDETAILCONFIG_H
       WHERE ingdetail_type = :NEW.ingdetail_type;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITINGDETAILCONFIG_H
                  ( ingdetail_type,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.ingdetail_type,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO ITINGDETAILCONFIG_H
                  ( ingdetail_type,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.ingdetail_type,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                --IS91_2
                --max_rev
                1
                --
           FROM ITINGDETAILCONFIG_h
          WHERE ingdetail_type = :NEW.ingdetail_type
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  --AND :NEW.intl = '0'
                  )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'id',
                    :NEW.ingdetail_type,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;
   -- IS194 start
   IF (:OLD.status <> :NEW.status)
   THEN
      UPDATE ITINGDETAILCONFIG_CHARASSOC
      SET status = :NEW.STATUS
      WHERE ingdetail_type = :OLD.ingdetail_type;
   END IF;
   -- IS194 end
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGDETAILCONFIG_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGDETCFG_CHARASSOC_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGDETCFG_CHARASSOC_OD" 
   AFTER DELETE
   ON ITINGDETAILCONFIG_CHARASSOC
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_ITINGDETCFG_CHARASSOC_OD';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
   INSERT INTO ITINGDETAILCONFIG_CHARASSOC_H
              ( ingredient,
                ingdetail_type,
                ingdetail_association,
                ingdetail_characteristic,
                seq_no,
                last_modified_on,
                last_modified_by,
                action )
           VALUES ( :OLD.ingredient,
                    :OLD.ingdetail_type,
                    :OLD.ingdetail_association,
                    :OLD.ingdetail_characteristic,
                    :OLD.seq_no,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D');

END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGDETCFG_CHARASSOC_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGDETCFG_CHARASSOC_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGDETCFG_CHARASSOC_OI" 
   BEFORE INSERT
   ON ITINGDETAILCONFIG_CHARASSOC
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_ITINGDETCFG_CHARASSOC_OI';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
   INSERT INTO ITINGDETAILCONFIG_CHARASSOC_H
              ( ingredient,
                ingdetail_type,
                ingdetail_association,
                ingdetail_characteristic,
                status,
                seq_no,
                last_modified_on,
                last_modified_by,
                action )
           VALUES ( :NEW.ingredient,
                    :NEW.ingdetail_type,
                    :NEW.ingdetail_association,
                    :NEW.ingdetail_characteristic,
                    :NEW.status,
                    :NEW.seq_no,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I');

END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGDETCFG_CHARASSOC_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGDETCFG_CHARASSOC_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGDETCFG_CHARASSOC_OU" 
   AFTER UPDATE
   ON ITINGDETAILCONFIG_CHARASSOC
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_ITINGDETCFG_CHARASSOC_OU';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   INSERT INTO ITINGDETAILCONFIG_CHARASSOC_H
              ( ingredient,
                ingdetail_type,
                ingdetail_association,
                ingdetail_characteristic,
                status,
                seq_no,
                last_modified_on,
                last_modified_by,
                action,
                new_ingredient,
                new_ingdetail_type,
                new_ingdetail_association,
                new_ingdetail_characteristic,
                new_status,
                new_seq_no )
           VALUES ( :OLD.ingredient,
                    :OLD.ingdetail_type,
                    :OLD.ingdetail_association,
                    :OLD.ingdetail_characteristic,
                    :OLD.status,
                    :OLD.seq_no,
                    sysdate,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.ingredient,
                    :NEW.ingdetail_type,
                    :NEW.ingdetail_association,
                    :NEW.ingdetail_characteristic,
                    :NEW.status,
                    :NEW.seq_no
 );
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGDETCFG_CHARASSOC_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGGROUPD_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGGROUPD_OD" 
   BEFORE DELETE
   ON ITINGGROUPD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow                       INTERSPC_CFG.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'TR_ITINGGROUPD_OD';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow
     FROM INTERSPC_CFG
    WHERE SECTION = 'interspec'
      AND parameter = 'allow_ingdet';

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND l_allow = '1'
   THEN
      INSERT INTO ITINGGROUPD_H
                  ( pid,
                    cid,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl,
					cid_type )
           VALUES ( :OLD.pid,
                    :OLD.cid,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    :OLD.intl,
					:OLD.cid_type );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGGROUPD_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGGROUPD_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGGROUPD_OI" 
   BEFORE INSERT
   ON ITINGGROUPD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow                       interspc_cfg.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'TR_ITINGGROUPD_OI';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow
     FROM interspc_cfg
    WHERE section = 'interspec'
      AND parameter = 'allow_ingdet';

   IF     l_allow = '1'
      AND (     ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' )
            OR (     :NEW.intl = '0'
                 AND (    iapiGeneral.SESSION.DATABASE.DatabaseType = 'R'
                       OR iapiGeneral.SESSION.DATABASE.DatabaseType = 'L' ) ) )
   THEN
      INSERT INTO ITINGGROUPD_H
                  ( pid,
                    cid,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl,
					cid_type )
           VALUES ( :NEW.pid,
                    :NEW.cid,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl,
					:NEW.cid_type );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGGROUPD_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGGROUPD_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGGROUPD_OU" 
   BEFORE UPDATE
   ON ITINGGROUPD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow                       interspc_cfg.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'TR_ITINGGROUPD_OU';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow
     FROM interspc_cfg
    WHERE section = 'interspec'
      AND parameter = 'allow_ingdet';

   IF     l_allow = '1'
      AND (     ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' )
            OR (     :NEW.intl = '0'
                 AND (    iapiGeneral.SESSION.DATABASE.DatabaseType = 'R'
                       OR iapiGeneral.SESSION.DATABASE.DatabaseType = 'L' ) ) )
   THEN
      INSERT INTO ITINGGROUPD_H
                  ( pid,
                    cid,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl,
					cid_type )
           VALUES ( :NEW.pid,
                    :NEW.cid,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl,
					:NEW.cid_type );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGGROUPD_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGREG_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGREG_OD" 
   BEFORE DELETE
   ON ITINGREG
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow                       interspc_cfg.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Itingreg_Od';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow
     FROM interspc_cfg
    WHERE section = 'interspec'
      AND parameter = 'allow_ingdet';

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND l_allow = '1'
   THEN
      INSERT INTO itingreg_h
                  ( ingredient,
                    reg_id,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :OLD.ingredient,
                    :OLD.reg_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    :OLD.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGREG_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGREG_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGREG_OI" 
   BEFORE INSERT
   ON ITINGREG
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow                       interspc_cfg.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Itingreg_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow
     FROM interspc_cfg
    WHERE section = 'interspec'
      AND parameter = 'allow_ingdet';

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND l_allow = '1'
   THEN
      INSERT INTO itingreg_h
                  ( ingredient,
                    reg_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.ingredient,
                    :NEW.reg_id,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGREG_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGREG_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGREG_OU" 
   BEFORE UPDATE
   ON ITINGREG
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow                       interspc_cfg.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Itingreg_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow
     FROM interspc_cfg
    WHERE SECTION = 'interspec'
      AND parameter = 'allow_ingdet';

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND l_allow = '1'
   THEN
      INSERT INTO itingreg_h
                  ( ingredient,
                    description,
                    reg_id,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl )
           VALUES ( :NEW.ingredient,
                    :NEW.description,
                    :NEW.reg_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGREG_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGSYNTYPES_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGSYNTYPES_OD" 
   BEFORE DELETE
   ON ITINGSYNTYPES
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow                       interspc_cfg.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'TR_ITINGSYNTYPES_OD';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow
     FROM interspc_cfg
    WHERE section = 'interspec'
      AND parameter = 'allow_ingdet';

   IF l_allow = '1'
   THEN
      INSERT INTO ITINGSYNTYPES_H
                  ( SYN_CID,
                    SYN_TYPE_CID,
                    LAST_MODIFIED_ON,
                    LAST_MODIFIED_BY,
                    ACTION )
           VALUES ( :OLD.SYN_CID,
                    :OLD.SYN_TYPE_CID,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D' );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGSYNTYPES_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGSYNTYPES_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGSYNTYPES_OI" 
   BEFORE INSERT
   ON ITINGSYNTYPES
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow                       interspc_cfg.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'TR_ITINGSYNTYPES_OI';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow
     FROM interspc_cfg
    WHERE section = 'interspec'
      AND parameter = 'allow_ingdet';

   IF  l_allow = '1'
   THEN
      INSERT INTO ITINGSYNTYPES_H
                  ( SYN_CID,
                    SYN_TYPE_CID,
                    LAST_MODIFIED_ON,
                    LAST_MODIFIED_BY,
                    ACTION )
           VALUES ( :NEW.SYN_CID,
                    :NEW.SYN_TYPE_CID,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I' );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGSYNTYPES_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITINGSYNTYPES_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITINGSYNTYPES_OU" 
   BEFORE UPDATE
   ON ITINGSYNTYPES
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_allow                       interspc_cfg.parameter_data%TYPE;
   lsSource                      iapiType.Source_Type := 'TR_ITINGSYNTYPES_OU';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT parameter_data
     INTO l_allow
     FROM interspc_cfg
    WHERE SECTION = 'interspec'
      AND parameter = 'allow_ingdet';

   IF l_allow = '1'
   THEN
      INSERT INTO ITINGSYNTYPES_H
                  ( SYN_CID,
                    SYN_TYPE_CID,
                    LAST_MODIFIED_ON,
                    LAST_MODIFIED_BY,
                    ACTION )
           VALUES ( :NEW.SYN_CID,
                    :NEW.SYN_TYPE_CID,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U' );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITINGSYNTYPES_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITKW_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITKW_OI" 
   AFTER INSERT
   ON ITKW
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Itkw_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO ITKW_H
                  ( kw_id,
                    revision,
                    description,
                    last_modified_on,
                    last_modified_by,
                    kw_type,
                    kw_usage )
           VALUES ( :NEW.kw_id,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.kw_type,
                    :NEW.kw_usage );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITKW_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITKW_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITKW_OU" 
   AFTER UPDATE OF description, kw_usage, kw_type, status
   ON ITKW
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   lsSource                      iapiType.Source_Type := 'Tr_Itkw_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND (    :OLD.description <> :NEW.description
            OR :OLD.kw_usage <> :NEW.kw_usage
            OR :OLD.kw_type <> :NEW.kw_type )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT   MAX( revision )
             + 1
        INTO l_next_val
        FROM ITKW_H
       WHERE kw_id = :NEW.kw_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITKW_H
                  ( kw_id,
                    revision,
                    description,
                    last_modified_on,
                    last_modified_by,
                    kw_type,
                    kw_usage )
           VALUES ( :NEW.kw_id,
                    l_next_val,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.kw_type,
                    :NEW.kw_usage );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND ( :OLD.status <> :NEW.status )
      AND iapiGeneral.SESSION.DATABASE.Configuration.glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'kw',
                    :NEW.kw_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITKW_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITKWCH_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITKWCH_OI" 
   BEFORE INSERT
   ON ITKWCH
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Itkwch_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO ITKWCH_H
                  ( ch_id,
                    revision,
                    description,
                    last_modified_on,
                    last_modified_by )
           VALUES ( :NEW.ch_id,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITKWCH_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITKWCH_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITKWCH_OU" 
   AFTER UPDATE OF description, status
   ON ITKWCH
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   lsSource                      iapiType.Source_Type := 'Tr_Itkwch_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.description <> :NEW.description
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT   MAX( revision )
             + 1
        INTO l_next_val
        FROM ITKWCH_H
       WHERE ch_id = :NEW.ch_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITKWCH_H
                  ( ch_id,
                    revision,
                    description,
                    last_modified_on,
                    last_modified_by )
           VALUES ( :NEW.ch_id,
                    l_next_val,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'kc',
                    :NEW.ch_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITKWCH_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITMFC_BD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITMFC_BD" 
BEFORE DELETE ON ITMFC
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
   lnRetVal                      Iapitype.ErrorNum_Type;
BEGIN
   DELETE
   FROM ITMFCMPL
   WHERE mfc_id = :OLD.mfc_id
   AND INTL='1';

   DELETE
   FROM ITMFCKW
   WHERE mfc_id = :OLD.mfc_id;

   IF Iapigeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := Iapigeneral.SetErrorTextAndLoginfo( 'TR_ITMFC_BD',
                                                      '',
                                                      Iapiconstantdberror.DBERR_NOINITSESSION );
      Iapigeneral.LogError( 'TR_ITMFC_BD',
                            '',
                            Iapigeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               Iapigeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     Iapigeneral.SESSION.DATABASE.DatabaseType IN ( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( Iapigeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND Iapigeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
         INSERT INTO ITMFC_H ( mfc_id,
                               description,
                               STATUS,
                               intl,
                               mtp_id,
                               action,
                               last_modified_on,
                               last_modified_by)
                      VALUES ( :OLD.mfc_id,
                               :OLD.description,
                               :OLD.STATUS,
                               :OLD.intl,
                               :OLD.mtp_id,
                               'D',
                               SYSDATE,
                               Iapigeneral.SESSION.ApplicationUser.UserId);
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITMFC_BD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITMFC_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITMFC_OI" 
   BEFORE INSERT
   ON ITMFC
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      Iapitype.ErrorNum_Type;
BEGIN
   IF Iapigeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := Iapigeneral.SetErrorTextAndLoginfo( 'TR_ITMFC_OI',
                                                      '',
                                                      Iapiconstantdberror.DBERR_NOINITSESSION );
      Iapigeneral.LogError( 'TR_ITMFC_OI',
                            '',
                            Iapigeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               Iapigeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     Iapigeneral.SESSION.DATABASE.DatabaseType IN ( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( Iapigeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND Iapigeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
         INSERT INTO ITMFC_H ( mfc_id,
                               description,
                               STATUS,
                               intl,
                               mtp_id,
                               action,
                               last_modified_on,
                               last_modified_by)
                      VALUES ( :NEW.mfc_id,
                               :NEW.description,
                               :NEW.STATUS,
                               :NEW.intl,
                               :NEW.mtp_id,
                               'I',
                               SYSDATE,
                               Iapigeneral.SESSION.ApplicationUser.UserId);
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITMFC_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITMFCMPL_BD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITMFCMPL_BD" 
BEFORE DELETE ON itmfcmpl
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

BEGIN
   DELETE
   FROM itmfcmplkw
   WHERE mpl_id = :old.mpl_id
   AND mfc_id = :old.mfc_id;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITMFCMPL_BD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITMFCMPL_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITMFCMPL_OU" AFTER UPDATE OF mpl_id ON ITMFCMPL REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 DECLARE
l_next_val NUMBER;
BEGIN
   UPDATE itprmfc
   SET mpl_id = :new.mpl_id
   where mpl_id = :old.mpl_id
   and mfc_id = :new.mfc_id;
END;

/
ALTER TRIGGER "INTERSPC"."TR_ITMFCMPL_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITMPL_BD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITMPL_BD" 
BEFORE DELETE ON ITMPL
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
   lnRetVal                      Iapitype.ErrorNum_Type;
BEGIN
   DELETE
   FROM ITMFCMPL
   WHERE mpl_id = :OLD.mpl_id
   AND INTL ='1';

   IF Iapigeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := Iapigeneral.SetErrorTextAndLoginfo( 'TR_ITMPL_BD',
                                                      '',
                                                      Iapiconstantdberror.DBERR_NOINITSESSION );
      Iapigeneral.LogError( 'TR_ITMPL_BD',
                            '',
                            Iapigeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               Iapigeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     Iapigeneral.SESSION.DATABASE.DatabaseType IN ( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( Iapigeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND Iapigeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
         INSERT INTO ITMPL_H ( mpl_id,
                               description,
                               STATUS,
                               intl,
                               action,
                               last_modified_on,
                               last_modified_by)
                      VALUES ( :OLD.mpl_id,
                               :OLD.description,
                               :OLD.intl,
                               :OLD.STATUS,
                               'D',
                               SYSDATE,
                               Iapigeneral.SESSION.ApplicationUser.UserId);
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITMPL_BD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITMPL_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITMPL_OI" 
   BEFORE INSERT
   ON ITMPL
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      Iapitype.ErrorNum_Type;
BEGIN
   IF Iapigeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := Iapigeneral.SetErrorTextAndLoginfo( 'TR_ITMPL_OI',
                                                      '',
                                                      Iapiconstantdberror.DBERR_NOINITSESSION );
      Iapigeneral.LogError( 'TR_ITMPL_OI',
                            '',
                            Iapigeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               Iapigeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     Iapigeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( Iapigeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND Iapigeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
         INSERT INTO ITMPL_H ( mpl_id,
                               description,
                               STATUS,
                               intl,
                               action,
                               last_modified_on,
                               last_modified_by)
                      VALUES ( :NEW.mpl_id,
                               :NEW.description,
                               :NEW.STATUS,
                               :NEW.intl,
                               'I',
                               SYSDATE,
                               Iapigeneral.SESSION.ApplicationUser.UserId);
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITMPL_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITMPL_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITMPL_OU" 
   AFTER UPDATE OF description, STATUS
   ON ITMPL
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      Iapitype.Source_Type := 'TR_ITMPL_OU';
   lnRetVal                      Iapitype.ErrorNum_Type;
BEGIN
   IF Iapigeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := Iapigeneral.SetErrorText( Iapiconstantdberror.DBERR_NOINITSESSION );
      Iapigeneral.LogError( lsSource,
                            '',
                            Iapigeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               Iapigeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     Iapigeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( Iapigeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND Iapigeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
         INSERT INTO ITMPL_H ( mpl_id,
                               description,
                               STATUS,
                               intl,
                               action,
                               last_modified_on,
                               last_modified_by)
                      VALUES ( :NEW.mpl_id,
                               :NEW.description,
                               :NEW.STATUS,
                               :NEW.intl,
                               'U',
                               SYSDATE,
                               Iapigeneral.SESSION.ApplicationUser.UserId);
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITMPL_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITNUTNOTE_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITNUTNOTE_OI" 
   BEFORE INSERT
   ON ITNUTNOTE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
--
--AP01116985 --AP01049325
--trigger is created for AP --AP01116985 --AP01049325
--
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
   lsSource                      iapiType.Source_Type := 'Tr_ItNutNote_Oi';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE itnutnote_h
         SET max_rev = 0
       WHERE nut_note_id = :NEW.nut_note_id;

      INSERT INTO itnutnote_H
                  ( nut_note_id,
                    revision,
                    lang_id,
                    description,
					long_description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.nut_note_id,
                    100,
                    1,
                    :NEW.description,
					:NEW.long_description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITNUTNOTE_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITNUTNOTE_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITNUTNOTE_OU" 
   AFTER UPDATE
   ON ITNUTNOTE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
--
--AP01116985 --AP01049325
--trigger is created for AP --AP01116985 --AP01049325
--
DECLARE
   l_next_val                    NUMBER;
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_ITNUTNOTE_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND (     (NVL( :OLD.description, ' ' ) <> NVL( :NEW.description, ' ' ) )
	  	  	OR	(NVL( :OLD.long_description, ' ' ) <> NVL( :NEW.long_description, ' ' ) ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM itnutnote_h
       WHERE nut_note_id = :NEW.nut_note_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE itnutnote_h
         SET max_rev = 0
       WHERE nut_note_id = :NEW.nut_note_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM itnutnote_H
       WHERE nut_note_id = :NEW.nut_note_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO ITNUTNOTE_H
                  ( nut_note_id,
                    revision,
                    lang_id,
                    description,
					long_description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.nut_note_id,
                    l_next_val,
                    1,
                    :NEW.description,
					:NEW.long_description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO ITNUTNOTE_H
                  ( nut_note_id,
                    revision,
                    lang_id,
                    description,
					long_description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.nut_note_id,
                l_next_val,
                lang_id,
                description,
				long_description,
                last_modified_on,
                last_modified_by,
                --IS190 --max_rev --orig
                1
           FROM itnutnote_h
          WHERE nut_note_id = :NEW.nut_note_id
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITNUTNOTE_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITPART_L
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITPART_L" BEFORE INSERT OR UPDATE  ON PART_L REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW
DECLARE
CURSOR c_indev_rev IS
  SELECT revision
  FROM specification_header sh, status ss
  WHERE sh.status = ss.status
  AND ss.status_type = 'DEVELOPMENT'
  AND sh.part_no = :new.part_no;
l_indev_rev specification_header.revision%TYPE;
BEGIN
   -- Could be that multiple revs are in dev (cfr multi_in_dev flag in interspc_cfg)
   FOR l_indev_rev IN c_indev_rev LOOP
      BEGIN
          INSERT INTO ITSHDESCR_L (part_no,revision,lang_id,description)
          VALUES (:new.part_no,l_indev_rev.revision,:new.lang_id,:new.description);
      EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         UPDATE ITSHDESCR_L
         SET description = :new.description
         WHERE part_no =:new.part_no
         AND revision = l_indev_rev.revision
         AND lang_id = :new.lang_id;
      END;
   END LOOP;
END;

/
ALTER TRIGGER "INTERSPC"."TR_ITPART_L" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITPRCL_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITPRCL_OD" AFTER  DELETE  ON ITPRCL REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 DECLARE
l_part_no part.part_no%TYPE;
BEGIN
   UPDATE itsh_h
   SET last_modified_on = SYSDATE
   WHERE part_no = :old.part_no;
END;

/
ALTER TRIGGER "INTERSPC"."TR_ITPRCL_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITPRCL_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITPRCL_OI" AFTER  INSERT  ON ITPRCL REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 BEGIN
   BEGIN
      INSERT INTO itsh_h VALUES (:new.part_no,SYSDATE);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         UPDATE itsh_h
         SET last_modified_on = SYSDATE
         WHERE part_no = :new.part_no;
   END;
END;

/
ALTER TRIGGER "INTERSPC"."TR_ITPRCL_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITPRCL_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITPRCL_OU" AFTER  UPDATE  ON ITPRCL REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 DECLARE
l_part_no part.part_no%TYPE;
l_owner   interspc_cfg.parameter_data%TYPE;
BEGIN
   UPDATE itsh_h
   SET last_modified_on = SYSDATE
   WHERE part_no = :old.part_no;
END;

/
ALTER TRIGGER "INTERSPC"."TR_ITPRCL_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITPRMFC_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITPRMFC_OD" 
   AFTER DELETE
   ON ITPRMFC
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_owner                       specification_header.owner%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Itprmfc_Od';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   UPDATE itsh_h
      SET last_modified_on = SYSDATE
    WHERE part_no = :OLD.part_no;

   SELECT MAX( owner )
     INTO l_owner
     FROM specification_header
    WHERE part_no = :OLD.part_no;

   IF l_owner = iapiGeneral.SESSION.DATABASE.Owner
   THEN
      INSERT INTO itprmfc_h
                  ( part_no,
                    last_modified_on,
                    action,
                    last_modified_by,
                    mfc_id,
                    mpl_id,
                    clearance_no,
                    trade_name,
                    audit_date,
                    audit_freq,
                    forename,
                    last_name,
                    product_code,
                    approval_date,
                    revision,
                    object_id,
                    object_revision,
                    object_owner )
           VALUES ( :OLD.part_no,
                    SYSDATE,
                    'D',
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :OLD.mfc_id,
                    :OLD.mpl_id,
                    :OLD.clearance_no,
                    :OLD.trade_name,
                    :OLD.audit_date,
                    :OLD.audit_freq,
                    iapiGeneral.SESSION.ApplicationUser.ForeName,
                    iapiGeneral.SESSION.ApplicationUser.LastName,
                    :OLD.product_code,
                    :OLD.approval_date,
                    :OLD.revision,
                    :OLD.object_id,
                    :OLD.object_revision,
                    :OLD.object_owner );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITPRMFC_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITPRMFC_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITPRMFC_OI" AFTER  INSERT  ON ITPRMFC REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

DECLARE
   l_owner specification_header.owner%TYPE;
BEGIN
   UPDATE itsh_h
   SET last_modified_on = SYSDATE
   WHERE part_no = :NEW.part_no;
   SELECT MAX(owner)
   INTO l_owner
   FROM specification_header
   WHERE part_no = :NEW.part_no;
   IF l_owner = iapiGeneral.Session.Database.Owner THEN
      INSERT INTO itprmfc_h (part_no, last_modified_on, action, last_modified_by, mfc_id, mpl_id, clearance_no, trade_name, audit_date, audit_freq,forename,last_name, product_code, approval_date, revision, object_id, object_revision, object_owner)
      VALUES (:NEW.part_no, SYSDATE, 'I', iapiGeneral.Session.ApplicationUser.UserId, :NEW.mfc_id, :NEW.mpl_id, :NEW.clearance_no, :NEW.trade_name, :NEW.audit_date, :NEW.audit_freq, iapiGeneral.Session.ApplicationUser.ForeName, iapiGeneral.Session.ApplicationUser.LastName, :new.product_code, :new.approval_date, :new.revision, :new.object_id, :new.object_revision, :new.object_owner) ;
   END IF;
END;

/
ALTER TRIGGER "INTERSPC"."TR_ITPRMFC_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITPRMFC_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITPRMFC_OU" 
   AFTER UPDATE
   ON ITPRMFC
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_owner                       specification_header.owner%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Itprmfc_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   UPDATE itsh_h
      SET last_modified_on = SYSDATE
    WHERE part_no = :OLD.part_no;

   SELECT MAX( owner )
     INTO l_owner
     FROM specification_header
    WHERE part_no = :OLD.part_no;

   IF l_owner = iapiGeneral.SESSION.DATABASE.Owner
   THEN
      INSERT INTO itprmfc_h
                  ( part_no,
                    last_modified_on,
                    action,
                    last_modified_by,
                    mfc_id,
                    mpl_id,
                    clearance_no,
                    trade_name,
                    audit_date,
                    audit_freq,
                    forename,
                    last_name,
                    product_code,
                    approval_date,
                    revision,
                    object_id,
                    object_revision,
                    object_owner )
           VALUES ( :OLD.part_no,
                    SYSDATE,
                    'D',
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :OLD.mfc_id,
                    :OLD.mpl_id,
                    :OLD.clearance_no,
                    :OLD.trade_name,
                    :OLD.audit_date,
                    :OLD.audit_freq,
                    iapiGeneral.SESSION.ApplicationUser.ForeName,
                    iapiGeneral.SESSION.ApplicationUser.LastName,
                    :OLD.product_code,
                    :OLD.approval_date,
                    :OLD.revision,
                    :OLD.object_id,
                    :OLD.object_revision,
                    :OLD.object_owner );

      INSERT INTO itprmfc_h
                  ( part_no,
                    last_modified_on,
                    action,
                    last_modified_by,
                    mfc_id,
                    mpl_id,
                    clearance_no,
                    trade_name,
                    audit_date,
                    audit_freq,
                    forename,
                    last_name,
                    product_code,
                    approval_date,
                    revision,
                    object_id,
                    object_revision,
                    object_owner )
           VALUES ( :NEW.part_no,
                    SYSDATE,
                    'I',
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.mfc_id,
                    :NEW.mpl_id,
                    :NEW.clearance_no,
                    :NEW.trade_name,
                    :NEW.audit_date,
                    :NEW.audit_freq,
                    iapiGeneral.SESSION.ApplicationUser.ForeName,
                    iapiGeneral.SESSION.ApplicationUser.LastName,
                    :NEW.product_code,
                    :NEW.approval_date,
                    :NEW.revision,
                    :NEW.object_id,
                    :NEW.object_revision,
                    :NEW.object_owner );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITPRMFC_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITPRNOTE_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITPRNOTE_OD" AFTER  DELETE  ON ITPRNOTE REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 BEGIN
   UPDATE itsh_h
   SET last_modified_on = SYSDATE
   WHERE part_no = :old.part_no;
END;

/
ALTER TRIGGER "INTERSPC"."TR_ITPRNOTE_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITPRNOTE_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITPRNOTE_OI" AFTER  INSERT  ON ITPRNOTE REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 BEGIN
  BEGIN
     INSERT INTO itsh_h VALUES (:new.part_no,SYSDATE);
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN
        UPDATE itsh_h
        SET last_modified_on = SYSDATE
        WHERE part_no = :new.part_no;
  END;
END;

/
ALTER TRIGGER "INTERSPC"."TR_ITPRNOTE_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITPRNOTE_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITPRNOTE_OU" AFTER  UPDATE  ON ITPRNOTE REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 BEGIN
   UPDATE itsh_h
   SET last_modified_on = SYSDATE
   WHERE part_no = :old.part_no;
END;

/
ALTER TRIGGER "INTERSPC"."TR_ITPRNOTE_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITPROBJ_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITPROBJ_OD" 
   AFTER DELETE
   ON itprobj
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Itprobj_Od';
   lnRetVal                      iapiType.ErrorNum_Type;
   l_owner                       specification_header.owner%TYPE;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   UPDATE itsh_h
      SET last_modified_on = SYSDATE
    WHERE part_no = :OLD.part_no;

   SELECT MAX( owner )
     INTO l_owner
     FROM specification_header
    WHERE part_no = :OLD.part_no;

   IF l_owner = iapiGeneral.SESSION.DATABASE.Owner
   THEN
      -- Note that the last_modified_on timestamp is a little bit manipulated.
      -- We will add 1 second to this date.
      --
      -- Reason: Copying a local specification to an international specification is
      --         done in iapiSpecification.CopySpecfication and to remove all local objects (itprobj), the
      --         function F_PART_LOC2INT is called. In the first procedure, an update of the
      --         revision causes the trigger TR_ITPROBJ_OU to log a "D" and "I" action in the history table.
      --         As a result of the second function, a delete is executed in the itprobj table,
      --         which causes the trigger TR_ITPROBJ_OD to log a "D" action in the history table.
      --         As I can see, a DUP_VAL_ON_INDEX is raised, because the calls are executed with exactly
      --         the same timestamp......
      INSERT INTO itprobj_h
                  ( part_no,
                    last_modified_on,
                    action,
                    last_modified_by,
                    object_id,
                    revision,
                    owner,
                    forename,
                    last_name )
           VALUES ( :OLD.part_no,
                      SYSDATE
                    +   1
                      / (   24
                          * 60
                          * 60 ),
                    'D',
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :OLD.object_id,
                    :OLD.revision,
                    :OLD.owner,
                    iapiGeneral.SESSION.ApplicationUser.ForeName,
                    iapiGeneral.SESSION.ApplicationUser.LastName );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITPROBJ_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITPROBJ_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITPROBJ_OI" 
   AFTER INSERT
   ON ITPROBJ
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Itprobj_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
   l_owner                       specification_header.owner%TYPE;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   UPDATE itsh_h
      SET last_modified_on = SYSDATE
    WHERE part_no = :NEW.part_no;

   SELECT MAX( owner )
     INTO l_owner
     FROM specification_header
    WHERE part_no = :NEW.part_no;

   IF l_owner = iapiGeneral.SESSION.DATABASE.Owner
   THEN
      INSERT INTO itprobj_h
                  ( part_no,
                    last_modified_on,
                    action,
                    last_modified_by,
                    object_id,
                    revision,
                    owner,
                    forename,
                    last_name )
           VALUES ( :NEW.part_no,
                    SYSDATE,
                    'I',
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.object_id,
                    :NEW.revision,
                    :NEW.owner,
                    iapiGeneral.SESSION.ApplicationUser.ForeName,
                    iapiGeneral.SESSION.ApplicationUser.LastName );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITPROBJ_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITPROBJ_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITPROBJ_OU" 
   AFTER UPDATE
   ON ITPROBJ
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_owner                       specification_header.owner%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Itprobj_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   UPDATE itsh_h
      SET last_modified_on = SYSDATE
    WHERE part_no = :OLD.part_no;

   SELECT MAX( owner )
     INTO l_owner
     FROM specification_header
    WHERE part_no = :OLD.part_no;

   IF l_owner = iapiGeneral.SESSION.DATABASE.Owner
   THEN
      INSERT INTO itprobj_h
                  ( part_no,
                    last_modified_on,
                    action,
                    last_modified_by,
                    object_id,
                    revision,
                    owner,
                    forename,
                    last_name )
           VALUES ( :OLD.part_no,
                    SYSDATE,
                    'D',
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :OLD.object_id,
                    :OLD.revision,
                    :OLD.owner,
                    iapiGeneral.SESSION.ApplicationUser.ForeName,
                    iapiGeneral.SESSION.ApplicationUser.LastName );

      INSERT INTO itprobj_h
                  ( part_no,
                    last_modified_on,
                    action,
                    last_modified_by,
                    object_id,
                    revision,
                    owner,
                    forename,
                    last_name )
           VALUES ( :NEW.part_no,
                    SYSDATE,
                    'I',
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.object_id,
                    :NEW.revision,
                    :NEW.owner,
                    iapiGeneral.SESSION.ApplicationUser.ForeName,
                    iapiGeneral.SESSION.ApplicationUser.LastName );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITPROBJ_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITREPAC_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITREPAC_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON itrepac
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   itrepac%ROWTYPE;
   lrNewRecord                   itrepac%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_ITREPAC_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.rep_id := :OLD.rep_id;
   lrOldRecord.user_group_id := :OLD.user_group_id;
   lrOldRecord.user_id := :OLD.user_id;
   lrOldRecord.access_type := :OLD.access_type;
   lrNewRecord.rep_id := :NEW.rep_id;
   lrNewRecord.user_group_id := :NEW.user_group_id;
   lrNewRecord.user_id := :NEW.user_id;
   lrNewRecord.access_type := :NEW.access_type;
   lnRetVal := iapiAuditTrail.AddReportAccessHistory( lsAction,
                                                      lrOldRecord,
                                                      lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITREPAC_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITREPARG_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITREPARG_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON itreparg
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   itreparg%ROWTYPE;
   lrNewRecord                   itreparg%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_ITREPARG_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.rep_id := :OLD.rep_id;
   lrOldRecord.rep_type := :OLD.rep_type;
   lrOldRecord.rep_arg1 := :OLD.rep_arg1;
   lrOldRecord.rep_dt_1 := :OLD.rep_dt_1;
   lrOldRecord.rep_arg2 := :OLD.rep_arg2;
   lrOldRecord.rep_dt_2 := :OLD.rep_dt_2;
   lrOldRecord.rep_arg3 := :OLD.rep_arg3;
   lrOldRecord.rep_dt_3 := :OLD.rep_dt_3;
   lrOldRecord.rep_arg4 := :OLD.rep_arg4;
   lrOldRecord.rep_dt_4 := :OLD.rep_dt_4;
   lrNewRecord.rep_id := :NEW.rep_id;
   lrNewRecord.rep_type := :NEW.rep_type;
   lrNewRecord.rep_arg1 := :NEW.rep_arg1;
   lrNewRecord.rep_dt_1 := :NEW.rep_dt_1;
   lrNewRecord.rep_arg2 := :NEW.rep_arg2;
   lrNewRecord.rep_dt_2 := :NEW.rep_dt_2;
   lrNewRecord.rep_arg3 := :NEW.rep_arg3;
   lrNewRecord.rep_dt_3 := :NEW.rep_dt_3;
   lrNewRecord.rep_arg4 := :NEW.rep_arg4;
   lrNewRecord.rep_dt_4 := :NEW.rep_dt_4;
   lnRetVal := iapiAuditTrail.AddReportArgHistory( lsAction,
                                                   lrOldRecord,
                                                   lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITREPARG_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITREPD_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITREPD_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON itrepd
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   itrepd%ROWTYPE;
   lrNewRecord                   itrepd%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_ITREPD_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.rep_id := :OLD.rep_id;
   lrOldRecord.sort_desc := :OLD.sort_desc;
   lrOldRecord.description := :OLD.description;
   lrOldRecord.info := :OLD.info;
   lrOldRecord.status := :OLD.status;
   lrOldRecord.rep_type := :OLD.rep_type;
   lrOldRecord.batch_allowed := :OLD.batch_allowed;
   lrOldRecord.web_allowed := :OLD.web_allowed;
   lrNewRecord.rep_id := :NEW.rep_id;
   lrNewRecord.sort_desc := :NEW.sort_desc;
   lrNewRecord.description := :NEW.description;
   lrNewRecord.info := :NEW.info;
   lrNewRecord.status := :NEW.status;
   lrNewRecord.rep_type := :NEW.rep_type;
   lrNewRecord.batch_allowed := :NEW.batch_allowed;
   lrNewRecord.web_allowed := :NEW.web_allowed;
   lnRetVal := iapiAuditTrail.AddReportHistory( lsAction,
                                                lrOldRecord,
                                                lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITREPD_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITREPDATA_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITREPDATA_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON itrepdata
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   itrepdata%ROWTYPE;
   lrNewRecord                   itrepdata%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_ITREPDATA_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.rep_id := :OLD.rep_id;
   lrOldRecord.nrep_type := :OLD.nrep_type;
   lrOldRecord.ref_id := :OLD.ref_id;
   lrOldRecord.ref_ver := :OLD.ref_ver;
   lrOldRecord.ref_owner := :OLD.ref_owner;
   lrOldRecord.include := :OLD.include;
   lrOldRecord.seq := :OLD.seq;
   lrOldRecord.header := :OLD.header;
   lrOldRecord.header_descr := :OLD.header_descr;
   lrOldRecord.display_format := :OLD.display_format;
   lrOldRecord.display_format_rev := :OLD.display_format_rev;
   lrOldRecord.incl_obj := :OLD.incl_obj;
   lrNewRecord.rep_id := :NEW.rep_id;
   lrNewRecord.nrep_type := :NEW.nrep_type;
   lrNewRecord.ref_id := :NEW.ref_id;
   lrNewRecord.ref_ver := :NEW.ref_ver;
   lrNewRecord.ref_owner := :NEW.ref_owner;
   lrNewRecord.include := :NEW.include;
   lrNewRecord.seq := :NEW.seq;
   lrNewRecord.header := :NEW.header;
   lrNewRecord.header_descr := :NEW.header_descr;
   lrNewRecord.display_format := :NEW.display_format;
   lrNewRecord.display_format_rev := :NEW.display_format_rev;
   lrNewRecord.incl_obj := :NEW.incl_obj;
   lnRetVal := iapiAuditTrail.AddReportDataHistory( lsAction,
                                                    lrOldRecord,
                                                    lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITREPDATA_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITREPG_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITREPG_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON itrepg
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   itrepg%ROWTYPE;
   lrNewRecord                   itrepg%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_ITREPG_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.repg_id := :OLD.repg_id;
   lrOldRecord.description := :OLD.description;
   lrNewRecord.repg_id := :NEW.repg_id;
   lrNewRecord.description := :NEW.description;
   lnRetVal := iapiAuditTrail.AddReportGroupHistory( lsAction,
                                                     lrOldRecord,
                                                     lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITREPG_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITREPITEMS_BU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITREPITEMS_BU" 
   BEFORE UPDATE OF TYPE, REP_ID, TEMPL_ID
   ON itrepitems
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Itrepitems_Bu';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   :NEW.last_modified_on := SYSDATE;
   :NEW.last_modified_by := iapiGeneral.SESSION.ApplicationUser.UserId;
EXCEPTION
   WHEN OTHERS
   THEN
      -- Consider logging the error and then re-raise
      RAISE;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITREPITEMS_BU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITREPITEMTYPE_BU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITREPITEMTYPE_BU" 
   BEFORE UPDATE OF TYPE, STANDARD, default_templ_id
   ON itrepitemtype
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Itrepitemtype_Bu';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   :NEW.last_modified_on := SYSDATE;
   :NEW.last_modified_by := iapiGeneral.SESSION.ApplicationUser.UserId;
EXCEPTION
   WHEN OTHERS
   THEN
      -- Consider logging the error and then re-raise
      RAISE;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITREPITEMTYPE_BU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITREPL_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITREPL_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON itrepl
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   itrepl%ROWTYPE;
   lrNewRecord                   itrepl%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_ITREPL_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.repg_id := :OLD.repg_id;
   lrOldRecord.rep_id := :OLD.rep_id;
   lrNewRecord.repg_id := :NEW.repg_id;
   lrNewRecord.rep_id := :NEW.rep_id;
   lnRetVal := iapiAuditTrail.AddReportLinkHistory( lsAction,
                                                    lrOldRecord,
                                                    lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   lnRetVal := iapiAuditTrail.AddReportGroupLinkHistory( lsAction,
                                                         lrOldRecord,
                                                         lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITREPL_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITREPNSTDEF_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITREPNSTDEF_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON itrepnstdef
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   itrepnstdef%ROWTYPE;
   lrNewRecord                   itrepnstdef%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_ITREPNSTDEF_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.rep_id := :OLD.rep_id;
   lrOldRecord.nrep_type := :OLD.nrep_type;
   lrOldRecord.nrep_d := :OLD.nrep_d;
   lrOldRecord.nrep_r := :OLD.nrep_r;
   lrOldRecord.nrep_l := :OLD.nrep_l;
   lrOldRecord.nrep_hl := :OLD.nrep_hl;
   lrOldRecord.nrep_d_lang := :OLD.nrep_d_lang;
   lrOldRecord.nrep_l_lang := :OLD.nrep_l_lang;
   lrOldRecord.remarks := :OLD.remarks;
   lrNewRecord.rep_id := :NEW.rep_id;
   lrNewRecord.nrep_type := :NEW.nrep_type;
   lrNewRecord.nrep_d := :NEW.nrep_d;
   lrNewRecord.nrep_r := :NEW.nrep_r;
   lrNewRecord.nrep_l := :NEW.nrep_l;
   lrNewRecord.nrep_hl := :NEW.nrep_hl;
   lrNewRecord.nrep_d_lang := :NEW.nrep_d_lang;
   lrNewRecord.nrep_l_lang := :NEW.nrep_l_lang;
   lrNewRecord.remarks := :NEW.remarks;
   lnRetVal := iapiAuditTrail.AddReportNstDefHistory( lsAction,
                                                      lrOldRecord,
                                                      lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITREPNSTDEF_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITREPSQL_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITREPSQL_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON itrepsql
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   itrepsql%ROWTYPE;
   lrNewRecord                   itrepsql%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_ITREPSQL_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.rep_id := :OLD.rep_id;
   lrOldRecord.sort_desc := :OLD.sort_desc;
   lrOldRecord.rep_sql1 := :OLD.rep_sql1;
   lrOldRecord.rep_sql2 := :OLD.rep_sql2;
   lrOldRecord.rep_sql3 := :OLD.rep_sql3;
   lrNewRecord.rep_id := :NEW.rep_id;
   lrNewRecord.sort_desc := :NEW.sort_desc;
   lrNewRecord.rep_sql1 := :NEW.rep_sql1;
   lrNewRecord.rep_sql2 := :NEW.rep_sql2;
   lrNewRecord.rep_sql3 := :NEW.rep_sql3;
   lnRetVal := iapiAuditTrail.AddReportSqlHistory( lsAction,
                                                   lrOldRecord,
                                                   lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITREPSQL_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITREPTEMPLATE_AU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITREPTEMPLATE_AU" 
   BEFORE UPDATE OF TEMPL_ID, TYPE
   ON ITREPTEMPLATE
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Itreptemplate_Au';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   :NEW.LAST_MODIFIED_ON := SYSDATE;
   :NEW.LAST_MODIFIED_BY := iapiGeneral.SESSION.ApplicationUser.UserId;
   NULL;
EXCEPTION
   WHEN OTHERS
   THEN
      -- Consider logging the error and then re-raise
      RAISE;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITREPTEMPLATE_AU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITSPECINGALLERGEN_AI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITSPECINGALLERGEN_AI" 
   AFTER INSERT
   ON ITSPECINGALLERGEN
   REFERENCING /*OLD AS OLD*/ NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_ITSPECINGALLERGEN_AI';
   lnRetVal                      iapiType.ErrorNum_Type;
   lnIntl                        iapitype.Boolean_Type;

   CURSOR c_props (lcAllergen IN ITINGALLERGEN.allergen%TYPE)
   IS
    SELECT property
    FROM itpropAllergen
    WHERE allergen = lcAllergen
    AND status = 0;

   --lcClaimType: 2 pos, 3 neg
   CURSOR c_claimProps ( lcPartNo   IN  ITSPECINGALLERGEN.part_no%TYPE,
                         lcRevision IN  ITSPECINGALLERGEN.revision%TYPE,
                         lcProperty IN  ITPROPALLERGEN.property%TYPE,
                         lcClaimType IN property_group.pg_type%TYPE)
   IS
    SELECT sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, sp.attribute
    FROM specification_prop sp, property_group pg
    WHERE sp.property_group = pg.property_group
    AND part_no = lcPartNo
    AND revision = lcRevision
    AND pg_type = lcClaimType
    AND property = lcProperty;

BEGIN
    -- Get the specification mode.
    lnRetVal := iapiSpecification.GetMode(:NEW.part_no,
                                          :NEW.revision,
                                           lnIntl);

    IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
    THEN
       iapiGeneral.LogInfo( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
       RAISE_APPLICATION_ERROR( -20000,
                                iapiGeneral.GetLastErrorText( ) );
    END IF;

   IF    (iapiGeneral.SESSION.SETTINGS.International = TRUE)
     AND (lnIntl = '0')
   THEN
        RETURN;
   END IF;

   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;


      FOR lrProps IN c_props( :NEW.allergen )
      LOOP
          --negative claims - check in bool1 field
          FOR lrClaimProps IN c_claimProps(:NEW.part_no, :NEW.revision, lrProps.property, 3)
          LOOP
            UPDATE specification_prop
            SET boolean_1 = 'Y' --for NEG claims
            WHERE part_no = lrClaimProps.part_no
            AND revision = lrClaimProps.revision
            AND section_id = lrClaimProps.section_id
            AND sub_section_id = lrClaimProps.sub_section_id
            AND property_group = lrClaimProps.property_group
            AND property = lrClaimProps.property
            AND attribute = lrClaimProps.attribute;
          END LOOP;

          --positive claims - uncheck bool1 field
          FOR lrClaimProps IN c_claimProps(:NEW.part_no, :NEW.revision, lrProps.property, 2)
          LOOP
            UPDATE specification_prop
            SET boolean_1 = 'N' --for POS claims
            WHERE part_no = lrClaimProps.part_no
            AND revision = lrClaimProps.revision
            AND section_id = lrClaimProps.section_id
            AND sub_section_id = lrClaimProps.sub_section_id
            AND property_group = lrClaimProps.property_group
            AND property = lrClaimProps.property
            and attribute = lrClaimProps.attribute;
          END LOOP;

      END LOOP;

EXCEPTION
WHEN OTHERS
THEN
    iapiGeneral.LogError( lsSource,
                          '',
                          'Cannot check/uncheck Claim property check box due to an error.' );
    iapiGeneral.LogError( lsSource,
                          '',
                          SQLERRM );
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITSPECINGALLERGEN_AI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITUMC_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITUMC_OI" 
   BEFORE INSERT
   ON ITUMC
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Itumc_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO ITUMC_h
                  ( uom_id,
                    uom_alt_id,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl,
                    conv_factor )
           VALUES ( :NEW.uom_id,
                    :NEW.uom_alt_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl,
                    :NEW.conv_factor );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITUMC_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_ITUMC_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_ITUMC_OU" 
   BEFORE UPDATE
   ON ITUMC
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Itumc_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO ITUMC_h
                  ( uom_id,
                    uom_alt_id,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl,
                    conv_factor )
           VALUES ( :NEW.uom_id,
                    :NEW.uom_alt_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl,
                    :NEW.conv_factor );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_ITUMC_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_IVUOM_UOM_GROUP_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_IVUOM_UOM_GROUP_OI" 
INSTEAD OF INSERT OR UPDATE OR DELETE
ON IVUOM_UOM_GROUP
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
   lnRetVal    iapiType.ErrorNum_Type;
   lnCountMetric      Number:=0;
   lnCountNon_Metric  Number:=0;
   anUomType         iapiType.Boolean_Type;
   TwoBase            EXCEPTION;

   PRAGMA EXCEPTION_INIT(TwoBase, -20511);

   PROCEDURE VerifyBaseTotal
   IS
   BEGIN
     BEGIN

      SELECT count(uom_id)
          INTO lnCountMetric
          FROM UOM_UOM_GROUP uug
         WHERE uug.UOM_GROUP = :NEW.uom_group
           AND uug.uom_id IN (SELECT u.uom_id
                                FROM uom u
                               WHERE u.uom_base = 1
                                 AND u.uom_id = uug.uom_id
                                 AND uom_type = 0);

     EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
          lnCountMetric:=0;
     END;

     BEGIN
      SELECT count(uom_id)
          INTO  lnCountNon_Metric
          FROM UOM_UOM_GROUP uug
         WHERE uug.UOM_GROUP = :NEW.uom_group
           AND uug.uom_id IN (SELECT u.uom_id
                                FROM uom u
                               WHERE u.uom_base = 1
                                 AND u.uom_id = uug.uom_id
                                 AND uom_type = 1);

     EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
          lnCountNon_Metric :=0;
     END;

     lnRetVal:= iapiUomGroups.GetTypeUom(:new.uom_id, anUomType);

     --if anUomType is not null
     --then
     --end if;


     IF (anUomType = 1 AND lnCountNon_Metric >= 1)
     THEN
      RAISE TwoBase;
     END IF;

     IF (anUomType = 0 AND lnCountMetric >= 1)
     THEN
      RAISE TwoBase;
     END IF;



   EXCEPTION
     WHEN TwoBase
     THEN

       lnRetVal := iapiGeneral.SetErrorTextAndLoginfo( 'TR_IVUOM_UOM_GROUP_OI',
                                                       '',
                                                        iapiConstantDbError.DBERR_INVALIDUOMCOMPONENT,
                                                        to_char(:NEW.uom_id),
                                                        to_char('Group:' || :NEW.UOM_GROUP) );

       iapiGeneral.LogError( 'TR_IVUOM_UOM_GROUP_OI',
                             '',
                             iapiGeneral.GetLastErrorText( ) );

       RAISE_APPLICATION_ERROR( -20511,
                                iapiGeneral.GetLastErrorText( ) );


   END;

BEGIN

   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorTextAndLoginfo( 'TR_IVUOM_UOM_GROUP_OI',
                                                      '',
                                                      iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_IVUOM_UOM_GROUP_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;


   IF UPDATING
   THEN
     --IF :NEW.UOM_BASE = 1
     --THEN
       -- VerifyBaseTotal;
     --END IF;
     UPDATE uom
        SET uom_base = :NEW.uom_base
     WHERE uom_id = DECODE(:NEW.uom_id, NULL,:OLD.uom_id, :NEW.uom_id);

   ELSIF INSERTING
   THEN
     BEGIN
       --IF :NEW.UOM_BASE = 1
       --THEN
         -- VerifyBaseTotal;
       --END IF;

       INSERT INTO uom_uom_group (UOM_GROUP, UOM_ID, INTL) VALUES(:NEW.UOM_GROUP, :NEW.UOM_ID, :NEW.INTL);

       UPDATE uom
          SET uom_base = :NEW.uom_base
        WHERE uom_id = :NEW.uom_id;


     EXCEPTION
       WHEN OTHERS
       THEN
       lnRetVal := iapiGeneral.SetErrorTextAndLoginfo( 'TR_IVUOM_UOM_GROUP_OI',
                                                       '',
                                                        iapiConstantDbError.DBERR_INVALIDUOMCOMPONENT,
                                                        to_char(:NEW.uom_id),
                                                        to_char('Group:' || :NEW.UOM_GROUP) );

       iapiGeneral.LogError( 'TR_IVUOM_UOM_GROUP_OI',
                             '',
                             iapiGeneral.GetLastErrorText( ) );

       RAISE_APPLICATION_ERROR( -20511,
                                iapiGeneral.GetLastErrorText( ) );
     END;
   ELSE
     DELETE UOM_UOM_GROUP WHERE UOM_ID = :OLD.uom_id;
     UPDATE uom
        SET uom_base = 0
     WHERE uom_id = DECODE(:NEW.uom_id, NULL,:OLD.uom_id, :NEW.uom_id);
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_IVUOM_UOM_GROUP_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_KW_DEL
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_KW_DEL" BEFORE  DELETE  ON ITKW FOR EACH ROW

 BEGIN
 DECLARE
 ls_errormessage VARCHAR2(255) ;
        BEGIN
  DELETE ITKWAS WHERE KW_ID = :old.kw_id ;
        EXCEPTION
                WHEN OTHERS THEN
   ls_errormessage := SUBSTR( '1  '||sqlerrm||'  '||:old.kw_id, 1, 255 ) ;
                        dbms_output.put_line(ls_errormessage ) ;
        END ;
END;

/
ALTER TRIGGER "INTERSPC"."TR_KW_DEL" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_LAYOUT_DEL
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_LAYOUT_DEL" BEFORE  DELETE  ON LAYOUT FOR EACH ROW

 BEGIN
        BEGIN
                DELETE FROM layout_validation WHERE layout_id = :old.layout_id AND revision = :old.revision ;
                DELETE FROM property_layout WHERE layout_id = :old.layout_id AND revision = :old.revision;
        EXCEPTION
                WHEN OTHERS THEN
                        dbms_output.put_line('1  '||sqlerrm||'  '||:new.layout_id) ;
        END ;
END;

/
ALTER TRIGGER "INTERSPC"."TR_LAYOUT_DEL" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_LAYOUT_UPDATE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_LAYOUT_UPDATE" 
 AFTER UPDATE OF STATUS ON LAYOUT
FOR EACH ROW

 BEGIN
        UPDATE property_layout a SET a.header_rev = (SELECT max(b.revision) FROM header_h b
                                                                                                WHERE a.header_id = b.header_id)
                WHERE a.layout_id = :NEW.layout_id
                  AND a.revision = :NEW.revision
									--TFS 3725 START
									AND :NEW.Status = 2;
									--TFS 3725 STOP;
END;
/
ALTER TRIGGER "INTERSPC"."TR_LAYOUT_UPDATE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_LICENSECHECK_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_LICENSECHECK_HS" 
AFTER INSERT
ON ATLICENSECHECK 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
   tmpVar NUMBER;
BEGIN
   INSERT INTO atlicensecheckhs
              (RECORD, lic_consumed,
               machine, terminal, logon_station, SID,
               user_name, user_description, osuser,
               logon_date, session_logon_time, LIC_CONS_SERIAL_ID, LIC_CONS_SHORTNAME, executable,
               job_last_run
              )
    VALUES (:NEW.record, :NEW.lic_consumed,
               :NEW.machine, :NEW.terminal, :NEW.logon_station, :NEW.sid,
               :NEW.user_name, :NEW.user_description, :NEW.osuser,
               :NEW.logon_date, :NEW.session_logon_time, :NEW.LIC_CONS_SERIAL_ID, :NEW.LIC_CONS_SHORTNAME, :NEW.executable,
               :NEW.job_last_run
              );
   EXCEPTION
     WHEN OTHERS THEN
       NULL;
END TR_LICENSECHECK_HS;

/
ALTER TRIGGER "INTERSPC"."TR_LICENSECHECK_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_LIMS_ATTACHED_SPEC
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_LIMS_ATTACHED_SPEC" 
   AFTER INSERT OR DELETE OR UPDATE
   ON ATTACHED_SPECIFICATION
   FOR EACH ROW
----------------------------------------------------------------------------
--   Project: interface Interspec-Unilab v6.31
-- $Revision: 2 $
--  $Modtime: 27/05/10 12:54 $
----------------------------------------------------------------------------


BEGIN

   --this column should maintain the attached_part_no column of the records located in itlimsplant
   IF DELETING THEN
      UPDATE itlimsjob
      SET attached_part_no=NULL
      WHERE part_no = :OLD.part_no
      AND revision = :OLD.revision;
   ELSIF UPDATING THEN
      IF :OLD.attached_part_no <> :NEW.attached_part_no THEN
            UPDATE itlimsjob
            SET attached_part_no=:NEW.attached_part_no
            WHERE part_no = :OLD.part_no
            AND revision = :OLD.revision;
      END IF;
   ELSIF INSERTING THEN
         UPDATE itlimsjob
         SET attached_part_no=:NEW.attached_part_no
         WHERE part_no = :NEW.part_no
         AND revision = :NEW.revision;
   END IF;
END;

/
ALTER TRIGGER "INTERSPC"."TR_LIMS_ATTACHED_SPEC" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_LIMS_OBSOLETECASCADESTEP1
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_LIMS_OBSOLETECASCADESTEP1" 
 AFTER INSERT OR UPDATE ON part_plant
 FOR EACH ROW
DECLARE

BEGIN
   --assumption done in this trigger
   --Interspec is never updating the flag for a set of record but one by one
   IF ((updating) AND :OLD.OBSOLETE = '0' AND :NEW.OBSOLETE = '1') OR
      ((inserting) AND :NEW.OBSOLETE = '1') THEN
      --if the current specification has some attached specification, cascade the obsoletion of the plant on all attched specifications
      PA_LIMS_CUSTOM.p_InitObsoleteCascade(:NEW.part_no, :NEW.plant);
   END IF;
END TR_LIMS_OBSOLETECASCADESTEP1;

/
ALTER TRIGGER "INTERSPC"."TR_LIMS_OBSOLETECASCADESTEP1" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TR_LIMS_OBSOLETECASCADESTEP2
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_LIMS_OBSOLETECASCADESTEP2" 
 AFTER INSERT OR UPDATE ON part_plant
DECLARE

BEGIN
   --assumption done in this trigger
   --Interspec is never updating the flag for a set of record but one by one
   PA_LIMS_CUSTOM.p_PerformObsoleteCascade;
END TR_LIMS_OBSOLETECASCADESTEP2;

/
ALTER TRIGGER "INTERSPC"."TR_LIMS_OBSOLETECASCADESTEP2" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_LIMS_PLANT
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_LIMS_PLANT" 
   BEFORE INSERT OR DELETE OR UPDATE
   ON ITLIMSPLANT
   FOR EACH ROW
----------------------------------------------------------------------------
--   Project: interface Interspec-Unilab v6.31
-- $Revision: 2 $
--  $Modtime: 27/05/10 12:54 $
----------------------------------------------------------------------------
DECLARE
   CURSOR l_PlantSpecification_Cursor(c_Plant part_plant.plant%TYPE) IS
      SELECT sph.part_no, sph.revision
        FROM specification_header sph, part_plant pp
       WHERE sph.status IN (SELECT status
                              FROM status
                             WHERE status_type = 'APPROVED'
                                OR status_type = 'CURRENT')
         AND pp.part_no = sph.part_no
         AND plant = c_plant
         AND NOT EXISTS (SELECT *
                           FROM itlimsjob
                          WHERE part_no = sph.part_no
                            AND revision = sph.revision
                            AND plant = c_plant);
BEGIN
   IF (inserting) THEN
      FOR l_PlantSpecification_Rec IN l_PlantSpecification_cursor(:new.plant) LOOP
         INSERT INTO itlimsjob(plant, part_no, revision, attached_part_no)
         VALUES(:new.plant, l_PlantSpecification_Rec.part_no, l_PlantSpecification_Rec.Revision, PA_LIMS.f_GetAttachedPartNo(l_PlantSpecification_Rec.part_no, l_PlantSpecification_Rec.Revision));
      END LOOP;
   END IF;

   IF (updating) THEN
      DELETE FROM itlimsjob
       WHERE plant = :old.plant
         AND (result_proceed IS NULL OR result_proceed = 0);

      FOR l_PlantSpecification_Rec IN l_PlantSpecification_cursor(:new.plant) LOOP
         INSERT INTO itlimsjob(plant, part_no, revision, attached_part_no)
         VALUES(:new.plant, l_PlantSpecification_Rec.part_no, l_PlantSpecification_Rec.Revision, PA_LIMS.f_GetAttachedPartNo(l_PlantSpecification_Rec.part_no, l_PlantSpecification_Rec.Revision));
      END LOOP;
   END IF;

   IF (deleting) THEN
      DELETE FROM itlimsjob
       WHERE plant = :old.plant
         AND (result_transfer IS NULL OR result_transfer = 0);
   END IF;
END;

/
ALTER TRIGGER "INTERSPC"."TR_LIMS_PLANT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_LIMS_SPC
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_LIMS_SPC" 
   AFTER UPDATE OF STATUS
   ON SPECIFICATION_HEADER
   FOR EACH ROW
----------------------------------------------------------------------------
--   Project: interface Interspec-Unilab v6.31
-- $Revision: 2 $
--  $Modtime: 27/05/10 12:54 $
----------------------------------------------------------------------------
DECLARE
   CURSOR l_GetStatusType_Cursor(c_Status specification_header.status%TYPE) IS
      SELECT status_type
        FROM status
       WHERE status = c_Status;

   CURSOR l_GetPlantForPart_Cursor(c_Part_No specification_header.part_no%TYPE) IS
      SELECT part_plant.plant, part_plant.obsolete
        FROM part_plant, itlimsplant
       WHERE part_plant.plant   = itlimsplant.plant
         AND part_plant.part_no = c_Part_No;

   CURSOR l_GetSpecInLIMS_cursor(c_Plant      plant.plant%TYPE,
                                 c_Part_No    specification_header.part_no%TYPE,
                                 c_Revision   specification_header.revision%TYPE) IS
      SELECT *
        FROM itlimsjob
       WHERE plant      = c_Plant
         AND part_no    = c_Part_No
         AND revision   = c_Revision
      FOR UPDATE;
BEGIN
-- The triggers determine which specifications can be transferred to Unilab.
   -- Get the status type
   FOR l_GetStatusType_Rec IN l_GetStatusType_Cursor(:new.Status) LOOP
      -- If the specification is approved, then it is ready to be processed for LIMS
      IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_GetStatusType_Rec.Status_Type, 'APPROVED') = 1 THEN
         -- Get all the plants for which the specification is valid
         FOR l_GetPlantForPart_Rec IN l_GetPlantForPart_Cursor(:new.part_no) LOOP
            INSERT INTO itlimsjob(plant, part_no, revision, to_be_updated, obsolete_updated, attached_part_no)
            VALUES(l_GetPlantForPart_Rec.Plant, :new.part_no, :new.Revision, '1', '1', PA_LIMS.f_GetAttachedPartNo(:new.part_no, :new.Revision));
         END LOOP;
      END IF;

      -- If the specification is historic and it is not yet transferred then the
      -- specification can not be transferred to unilab 4.
      IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_GetStatusType_Rec.Status_Type, 'OBSOLETE') = 1 OR
         PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_GetStatusType_Rec.Status_Type, 'HISTORIC') = 1 THEN
         -- Get all the plants for which the specification is valid
         FOR l_GetPlantForPart_Rec IN l_GetPlantForPart_Cursor(:new.part_no) LOOP
            -- Get all the plants for which the specification is not yet transferred
            FOR l_GetSpecInLIMS_rec IN l_GetSpecInLIMS_cursor(l_GetPlantForPart_Rec.Plant, :new.part_no, :new.revision) LOOP
               -- Delete the specification from ITLIMSJOB
               DELETE FROM itlimsjob
               WHERE CURRENT OF l_GetSpecInLIMS_cursor;
            END LOOP;
         END LOOP;
      END IF;
   END LOOP;
END;

/
ALTER TRIGGER "INTERSPC"."TR_LIMS_SPC" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_LIMS_UPDATE_ON_EFFDATE_MOD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_LIMS_UPDATE_ON_EFFDATE_MOD" 
   AFTER INSERT
   ON jrnl_specification_header
   FOR EACH ROW
----------------------------------------------------------------------------
--   Project: interface Interspec-Unilab v6.31
-- $Revision: 2 $
--  $Modtime: 27/05/10 12:54 $
----------------------------------------------------------------------------
DECLARE
BEGIN
   UPDATE itlimsjob
   SET to_be_updated = '1',
       result_last_update = NULL,
       result_proceed = NULL
   WHERE part_no = :NEW.part_no
   AND revision = :NEW.revision;
   --this record might eventually update no record. This case is not catched since it
   --can be normal that a part is present in Interspec but not linked to a LIMS
END;

/
ALTER TRIGGER "INTERSPC"."TR_LIMS_UPDATE_ON_EFFDATE_MOD" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TR_LIMS_UPDATE_ON_KW_MODIF
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_LIMS_UPDATE_ON_KW_MODIF" 
   AFTER INSERT
   ON specification_kw_h
   FOR EACH ROW
----------------------------------------------------------------------------
--   Project: interface Interspec-Unilab v6.31
-- $Revision: 2 $
--  $Modtime: 27/05/10 12:54 $
----------------------------------------------------------------------------
DECLARE
l_count    INTEGER;
BEGIN
   SELECT count(*)
   INTO l_count
   FROM itlimsconfkw
   WHERE kw_id = :NEW.kw_id;
   --only mark as to be updated when a keyword linked to a LIMS property has changed
   IF l_count > 0 THEN
      UPDATE itlimsjob
      SET to_be_updated = '1',
          result_last_update = NULL,
          result_proceed = NULL
      WHERE part_no = :NEW.part_no;
      --this record might eventually update no record. This case is not catched since it
      --can be normal that a part is present in Interspec but not linked to a LIMS
   END IF;
END;

/
ALTER TRIGGER "INTERSPC"."TR_LIMS_UPDATE_ON_KW_MODIF" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TR_LIMS_UPDATE_ON_PPLANT_MODIF
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_LIMS_UPDATE_ON_PPLANT_MODIF" 
   AFTER INSERT OR DELETE OR UPDATE
   ON part_plant
   FOR EACH ROW
----------------------------------------------------------------------------
--   Project: interface Interspec-Unilab v6.31
-- $Revision: 2 $
--  $Modtime: 27/05/10 12:54 $
----------------------------------------------------------------------------
DECLARE
   CURSOR l_PlantSpecification_Cursor(c_part_no part_plant.part_no%TYPE, c_Plant part_plant.plant%TYPE) IS
      SELECT sph.part_no, sph.revision
        FROM specification_header sph
       WHERE sph.status IN (SELECT status
                              FROM status
                             WHERE status_type = 'APPROVED'
                                OR status_type = 'CURRENT')
         AND sph.part_no = c_part_no
         AND NOT EXISTS (SELECT *
                           FROM itlimsjob
                          WHERE part_no = c_part_no
                            AND revision = sph.revision
                            AND plant = c_plant)
         AND EXISTS (SELECT 'X' FROM itlimsplant WHERE plant = c_plant);
   l_date_transferred       DATE;
BEGIN
   IF (inserting) THEN
      IF NVL(:new.obsolete, '0') <> '1' THEN
         FOR l_PlantSpecification_Rec IN l_PlantSpecification_cursor(:new.part_no, :new.plant) LOOP
            INSERT INTO itlimsjob(plant, part_no, revision, to_be_updated, obsolete_updated, attached_part_no)
            VALUES(:new.plant, :new.part_no, l_PlantSpecification_Rec.Revision, '1', '1', PA_LIMS.f_GetAttachedPartNo(:new.part_no, l_PlantSpecification_Rec.Revision));
         END LOOP;
      ELSE
         FOR l_PlantSpecification_Rec IN l_PlantSpecification_cursor(:new.part_no, :new.plant) LOOP
            INSERT INTO itlimsjob(plant, part_no, revision, to_be_updated, obsolete_updated, attached_part_no)
            VALUES(:new.plant, :new.part_no, l_PlantSpecification_Rec.Revision, '1', '1', PA_LIMS.f_GetAttachedPartNo(:new.part_no, l_PlantSpecification_Rec.Revision));
         END LOOP;
      END IF;
   END IF;

   IF (deleting) THEN
      DELETE FROM itlimsjob
       WHERE plant = :old.plant
         AND part_no = :old.part_no
         AND (result_transfer IS NULL OR result_transfer = 0);
   END IF;

   IF (updating) THEN
      BEGIN
         SELECT date_transferred
         INTO l_date_transferred
         FROM itlimsjob
         WHERE plant = :old.plant
           AND part_no = :old.part_no
         FOR UPDATE;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_date_transferred := NULL;
      WHEN TOO_MANY_ROWS THEN
         --some records found (TO TEST)
         l_date_transferred := SYSDATE;
      END;
      IF l_date_transferred IS NULL THEN
         IF NVL(:new.obsolete, '0') = '0' AND NVL(:old.obsolete, '0') = '1' THEN
            --mark as to be transferred
            FOR l_PlantSpecification_Rec IN l_PlantSpecification_cursor(:new.part_no, :new.plant) LOOP
               INSERT INTO itlimsjob(plant, part_no, revision, attached_part_no)
               VALUES(:new.plant, :new.part_no, l_PlantSpecification_Rec.Revision, PA_LIMS.f_GetAttachedPartNo(:new.part_no, l_PlantSpecification_Rec.Revision));
            END LOOP;
         END IF;
      ELSE
         IF NVL(:new.obsolete, '0') <> NVL(:old.obsolete, '0') THEN
            UPDATE itlimsjob
            SET obsolete_updated = '1',
                to_be_updated = '1',
                result_last_update = NULL,
                result_proceed = NULL
            WHERE plant = :old.plant
              AND part_no = :old.part_no;
         END IF;
      END IF;
   END IF;


END;

/
ALTER TRIGGER "INTERSPC"."TR_LIMS_UPDATE_ON_PPLANT_MODIF" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_LIMS_UPDATE_ON_STATUS_MODIF
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_LIMS_UPDATE_ON_STATUS_MODIF" 
   AFTER INSERT
   ON status_history
   FOR EACH ROW
----------------------------------------------------------------------------
--   Project: interface Interspec-Unilab v6.31
-- $Revision: 2 $
--  $Modtime: 27/05/10 12:54 $
----------------------------------------------------------------------------
DECLARE
BEGIN
   UPDATE itlimsjob
   SET to_be_updated = '1',
       result_last_update = NULL,
       result_proceed = NULL
   WHERE part_no = :NEW.part_no
   AND revision = :NEW.revision;
   --this record might eventually update no record. This case is not catched since it
   --can be normal that a part is present in Interspec but not linked to a LIMS
END;

/
ALTER TRIGGER "INTERSPC"."TR_LIMS_UPDATE_ON_STATUS_MODIF" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_MATERIAL_CLASS_DEL
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_MATERIAL_CLASS_DEL" 
   AFTER DELETE
   ON MATERIAL_CLASS
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Material_Class_Del';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   lnRetVal := iapiEvent.SinkEvent( iapiConstant.ClassifNodeRemoved,
                                       TO_CHAR( :OLD.IDENTIFIER )
                                    || '|'
                                    || :OLD.LONG_NAME );

   IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_MATERIAL_CLASS_DEL" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_MATERIAL_CLASS_NEW
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_MATERIAL_CLASS_NEW" 
   AFTER INSERT
   ON MATERIAL_CLASS
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Material_Class_New';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   lnRetVal := iapiEvent.SinkEvent( iapiConstant.ClassifNodeCreated,
                                       TO_CHAR( :NEW.IDENTIFIER )
                                    || '|'
                                    || :NEW.LONG_NAME );

   IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_MATERIAL_CLASS_NEW" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_MATERIAL_CLASS_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_MATERIAL_CLASS_OD" BEFORE DELETE ON MATERIAL_CLASS REFERENCING OLD AS OLD NEW AS NEW
BEGIN
UPDATE interspc_cfg
SET parameter_data = to_char(SYSDATE,'DD/MM/YYYY HH24:MI:SS')
WHERE parameter = 'last_modified_on'
AND section = 'Classification';
END;
/
ALTER TRIGGER "INTERSPC"."TR_MATERIAL_CLASS_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_MATERIAL_CLASS_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_MATERIAL_CLASS_OI" BEFORE INSERT ON MATERIAL_CLASS REFERENCING OLD AS OLD NEW AS NEW
BEGIN
UPDATE interspc_cfg
SET parameter_data = to_char(SYSDATE,'DD/MM/YYYY HH24:MI:SS')
WHERE parameter = 'last_modified_on'
AND section = 'Classification';
END;
/
ALTER TRIGGER "INTERSPC"."TR_MATERIAL_CLASS_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_MATERIAL_CLASS_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_MATERIAL_CLASS_OU" AFTER UPDATE ON MATERIAL_CLASS REFERENCING OLD AS OLD NEW AS NEW
BEGIN
UPDATE interspc_cfg
SET parameter_data = to_char(SYSDATE,'DD/MM/YYYY HH24:MI:SS')
WHERE parameter = 'last_modified_on'
AND section = 'Classification';
END;
/
ALTER TRIGGER "INTERSPC"."TR_MATERIAL_CLASS_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_MFC_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_MFC_OU" 
   AFTER UPDATE OF description, STATUS
   ON ITMFC
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      Iapitype.Source_Type := 'Tr_Mfc_Ou';
   lnRetVal                      Iapitype.ErrorNum_Type;
BEGIN
   IF Iapigeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := Iapigeneral.SetErrorText( Iapiconstantdberror.DBERR_NOINITSESSION );
      Iapigeneral.LogError( lsSource,
                            '',
                            Iapigeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               Iapigeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     Iapigeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( Iapigeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND Iapigeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
         INSERT INTO ITMFC_H ( mfc_id,
                               description,
                               STATUS,
                               intl,
                               mtp_id,
                               action,
                               last_modified_on,
                               last_modified_by)
                      VALUES ( :NEW.mfc_id,
                               :NEW.description,
                               :NEW.STATUS,
                               :NEW.intl,
                               :NEW.mtp_id,
                               'U',
                               SYSDATE,
                               Iapigeneral.SESSION.ApplicationUser.UserId);
   END IF;

   IF     (     (     Iapigeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( Iapigeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.STATUS <> :NEW.STATUS
      AND Iapigeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO ITENSSLOG
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    STATUS )
           VALUES ( 'mf',
                    :NEW.mfc_id,
                    SYSDATE,
                    Iapigeneral.SESSION.ApplicationUser.UserId,
                    :NEW.STATUS );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_MFC_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_OI_SPEC_PREFIX_DESCR
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_OI_SPEC_PREFIX_DESCR" 
   AFTER INSERT
   ON SPEC_PREFIX_DESCR
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
/* After inserting specification prefix, insert a record in spec_prefix */
BEGIN
   IF iapiGeneral.SESSION.DATABASE.DatabaseType = 'G'
   THEN
      INSERT INTO spec_prefix
                  ( owner,
                    prefix,
                    destination )
           VALUES ( :NEW.owner,
                    :NEW.prefix,
                    :NEW.owner );
   END IF;
END SPEC_PREFIX;
/
ALTER TRIGGER "INTERSPC"."TR_OI_SPEC_PREFIX_DESCR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PART_AI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PART_AI" 
AFTER INSERT ON part
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

BEGIN
   -- descriptions and language codes should be managed by masterdata interface
   IF :new.part_source = 'I-S' THEN
      INSERT
      INTO part_l (part_no, lang_id, description)
      VALUES (:new.part_no, 1, :new.description);
   END IF;
END tr_part_ai;

/
ALTER TRIGGER "INTERSPC"."TR_PART_AI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PART_AU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PART_AU" 
AFTER UPDATE OF description ON part
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

BEGIN
   -- descriptions and language codes should be managed by masterdata interface
   IF :new.part_source = 'I-S' THEN

      UPDATE part_l
      SET description = :new.description
      WHERE part_no = :new.part_no
      --IS68 Start
      --AND lang_id = 1; --orig
       AND lang_id = iapiGeneral.SESSION.SETTINGS.LanguageId;
      --IS68 End

   END IF;
END tr_part_au;

/
ALTER TRIGGER "INTERSPC"."TR_PART_AU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PART_BD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PART_BD" 
BEFORE DELETE ON part
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
DELETE
FROM part_l
WHERE part_no = :old.part_no;
END tr_part_bd;
/
ALTER TRIGGER "INTERSPC"."TR_PART_BD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PART_COST
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PART_COST" AFTER INSERT ON PART_COST REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 BEGIN
INSERT INTO price_type(price_type, period)
VALUES(:new.price_type, :new.period) ;
EXCEPTION
WHEN OTHERS THEN
null;
END;

/
ALTER TRIGGER "INTERSPC"."TR_PART_COST" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PART_COST_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PART_COST_OU" AFTER UPDATE ON PART_COST REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 DECLARE
BEGIN
IF :old.currency <> :new.currency THEN
INSERT INTO itimp_changes (object_type,item,what,old_value,new_value,timestamp)
VALUES ('Part/PriceTyp/Peri.',:old.part_no||'/'||:old.price_type||'/'||:old.period,'Currency',:old.currency,:new.currency,SYSDATE);
END IF;
IF :old.price <> :new.price THEN
INSERT INTO itimp_changes (object_type,item,what,old_value,new_value,timestamp)
VALUES ('Part/PriceTyp/Peri.',:old.part_no||'/'||:old.price_type||'/'||:old.period,'Price',:old.price,:new.price,SYSDATE);
END IF;
IF :old.uom <> :new.uom THEN
INSERT INTO itimp_changes (object_type,item,what,old_value,new_value,timestamp)
VALUES ('Part/PriceTyp/Peri.',:old.part_no||'/'||:old.price_type||'/'||:old.period,'UOM',:old.uom,:new.uom,SYSDATE);
END IF;
END;

/
ALTER TRIGGER "INTERSPC"."TR_PART_COST_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PART_DESCR
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PART_DESCR" 
	   BEFORE INSERT  OR UPDATE
	   ON PART
	   REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW
DECLARE

CURSOR c_indev_rev IS
  SELECT revision
  FROM specification_header sh, status ss
  WHERE sh.status = ss.status
  AND ss.status_type = 'DEVELOPMENT'
  AND sh.part_no = :new.part_no;

l_old_type class3.type%TYPE;
l_new_type class3.type%TYPE;
l_indev_rev specification_header.revision%TYPE;

BEGIN

   -----
   -- Changes to the description
   -----
   IF :old.description <> :new.description AND :new.description IS NOT NULL THEN

	  FOR l_indev_rev IN c_indev_rev LOOP
         -- Could be that multiple revs are in dev (cfr multi_in_dev flag in interspc_cfg)
         UPDATE specification_header
         SET description = :new.description
         WHERE part_no =:old.part_no
         AND revision = l_indev_rev.revision;
      END LOOP;

      -- Only log changes made by the interface (imp stands for IMPORT !)
      IF :old.part_source <> 'I-S' THEN
         INSERT INTO itimp_changes (object_type,item,what,old_value,new_value,timestamp)
         VALUES ('Part',:old.part_no,'Description',:old.description,:new.description,SYSDATE);
      END IF;

   END IF ;

   -----
   -- Changes to the part type
   -----
   IF :new.part_type <> 0 AND :old.part_type <> :new.part_type THEN

      UPDATE specification_header
      SET class3_id = :new.part_type
      WHERE part_no =:old.part_no;

      SELECT type
      INTO l_old_type
      FROM class3
      WHERE class = :old.part_type;

      SELECT type
      INTO l_new_type
      FROM class3
      WHERE class = :new.part_type;

      IF l_new_type <> l_old_type THEN
         DELETE itprcl WHERE part_no = :new.part_no;
      END IF;

   END IF ;


   -----
   -- Changes to the part type
   -----
   IF :old.obsolete <> :new.obsolete AND :old.part_source <> 'I-S' THEN

      IF :new.obsolete = 1 THEN
         INSERT INTO itimp_changes (object_type,item,what,old_value,new_value,timestamp)
         VALUES ('Part',:old.part_no,'Obsolete flag','Not Obsolete','Obsolete',SYSDATE);
      ELSE
         INSERT INTO itimp_changes (object_type,item,what,old_value,new_value,timestamp)
         VALUES ('Part',:old.part_no,'Obsolete flag','Obsolete','Not Obsolete',SYSDATE);
      END IF;
   END IF;

END;
/
ALTER TRIGGER "INTERSPC"."TR_PART_DESCR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PART_OU_UOM
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PART_OU_UOM" 
   AFTER UPDATE OF BASE_UOM, PART_SOURCE
   ON PART
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_count                       PLS_INTEGER := 0;
   msgLogErr					 VARCHAR2(500);

   CURSOR c_check
   IS
      SELECT TO_CHAR(status_type)
        FROM specification_header sh,
             bom_header bh,
             status ss
       WHERE sh.part_no = bh.part_no
         AND sh.revision = bh.revision
         AND sh.status = ss.status
         AND ss.status_type <> 'DEVELOPMENT'
         AND sh.part_no = :NEW.part_no
      UNION
      SELECT to_char(bh.calc_flag)
        FROM bom_header bh
       WHERE bh.part_no = :NEW.part_no
         AND bh.calc_flag <> 'N'
      UNION
      SELECT  to_char(bi.calc_flag)
        FROM bom_item bi
       WHERE bi.component_part = :NEW.part_no
         AND bi.calc_flag <> 'N';

   l_bom_header_count            NUMBER;
   l_ret                         NUMBER;
BEGIN
   IF :OLD.base_uom <> :NEW.base_uom
   THEN
      FOR l_row IN c_check
      LOOP
         l_count                    :=   l_count
                                       + 1;
      END LOOP;

      l_ret                      := F_AO_VALIDATE_UOM( :NEW.part_no,
                                                       :OLD.base_uom,
                                                       :NEW.base_uom );

      IF    l_count > 0
         OR l_ret < 0
      THEN
	  	 msgLogErr:= 'UOM can not be changed for the part ' ||  :OLD.part_no || '. It''is the basis of a non in dev specification.';
	  	 iapiGeneral.LogError( 'Event TRIGGER',
                 		       'TR_PART_OU_UOM',
                               msgLogErr );
         RAISE_APPLICATION_ERROR( -20751,
                                  msgLogErr );
         NULL;
      END IF;

      INSERT INTO itimp_changes
                  ( object_type,
                    item,
                    what,
                    old_value,
                    new_value,
                    TIMESTAMP )
           VALUES ( 'Part',
                    :OLD.part_no,
                    'UOM',
                    :OLD.base_uom,
                    :NEW.base_uom,
                    SYSDATE );
   END IF;

   IF    (     :OLD.part_source = 'MFG'
           AND :NEW.part_source = 'SAP' )
      OR (     :OLD.part_source = 'SAP'
           AND :NEW.part_source = 'MFG' )
   THEN
      SELECT COUNT( part_no )
        INTO l_bom_header_count
        FROM bom_header
       WHERE part_no = :NEW.part_no;

      IF l_bom_header_count > 0
      THEN
         RAISE_APPLICATION_ERROR( -20752,
                                  'Part source cannot be changed from MFG to SAP or vice versa.' );
      END IF;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_PART_OU_UOM" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PART_PLANT_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PART_PLANT_AD" 
   AFTER DELETE
   ON part_plant
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Part_Plant_Ad';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   lnRetVal := iapiPlantPart.RemovePartFromPlant( :OLD.plant,
                                                  :OLD.part_no );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   ELSE

   --R18
   --TODO  NVL(exp, val)  has to be applied for each old row to make deletion working..
   --in addition old verifications were like this: --AND   new_plant_access       = NULL.... not correct
   DELETE ITPRPL_H
        WHERE   part_no   = :OLD.part_no
          AND   old_plant = :OLD.plant
          AND   new_plant IS NULL
          AND   NVL(old_issue_uom, 0) =  NVL(:OLD.issue_uom , 0)
          AND   new_issue_uom IS null
          AND   NVL(old_assembly_scrap, 0) =  NVL(:OLD.assembly_scrap, 0)
          AND   new_assembly_scrap IS NULL
          AND   NVL(old_component_scrap, 0) =  NVL(:OLD.component_scrap, 0)
          AND   new_component_scrap IS NULL
          AND   NVL(old_lead_time_offset, 0) = NVL(:OLD.lead_time_offset, 0)
          AND   new_lead_time_offset IS NULL
          AND   NVL(old_relevency_to_costing, 0) = NVL(:OLD.relevency_to_costing, 0)
          AND   new_relevency_to_costing IS NULL
          AND   NVL(old_bulk_material, 0) =  NVL(:OLD.bulk_material, 0)
          AND   new_bulk_material IS  NULL
          AND   NVL(old_item_category, 0) =  NVL(:OLD.item_category, 0)
          AND   new_item_category IS  NULL
          AND   NVL(old_issue_location, 0) = NVL(:OLD.issue_location, 0)
          AND   new_issue_location IS  NULL
          AND   NVL(old_discontinuation_indicator, 0) =  NVL(:OLD.discontinuation_indicator, 0)
          AND   new_discontinuation_indicator IS  NULL
          AND   NVL(old_follow_on_material, 0) =  NVL(:OLD.follow_on_material, 0)
          AND   new_follow_on_material IS  NULL
          AND   NVL(old_commodity_code, 0)     =  NVL(:OLD.commodity_code, 0)
          AND   new_commodity_code     IS  NULL
          AND   NVL(old_operational_step, 0)   =  NVL(:OLD.operational_step, 0)
          AND   new_operational_step   IS  NULL
          AND   NVL(old_obsolete, 0)           =  NVL(:OLD.obsolete, 0)
          AND   new_obsolete           IS  NULL
          AND   NVL( old_plant_access, 0)       =  NVL(:OLD.plant_access, 0)
          --R18 Revert
          --AND   new_plant_access       = NULL; --orig
          AND   new_plant_access       IS  NULL
          AND   NVL(old_component_scrap_sync, 0) =  NVL(:OLD.component_scrap_sync, 0)
          AND   new_component_scrap_sync IS  NULL;
          --AND  NVL(old_ACTUAL_STATUS, 0) =  NVL(:OLD.ACTUAL_STATUS, 0)
          --AND  new_ACTUAL_STATUS IS NULL
          --AND  NVL(old_PLANNED_STATUS, 0) = NVL(:OLD.PLANNED_STATUS, 0)
          --AND  new_PLANNED_STATUS IS NULL;
          --R18 End

      INSERT INTO itprpl_h
                  ( part_no,
                    action,
                    old_plant,
                    new_plant,
                    old_issue_uom,
                    new_issue_uom,
                    old_assembly_scrap,
                    new_assembly_scrap,
                    old_component_scrap,
                    new_component_scrap,
                    old_lead_time_offset,
                    new_lead_time_offset,
                    old_relevency_to_costing,
                    new_relevency_to_costing,
                    old_bulk_material,
                    new_bulk_material,
                    old_item_category,
                    new_item_category,
                    old_issue_location,
                    new_issue_location,
                    old_discontinuation_indicator,
                    new_discontinuation_indicator,
                    old_discontinuation_date,
                    new_discontinuation_date,
                    old_follow_on_material,
                    new_follow_on_material,
                    old_commodity_code,
                    new_commodity_code,
                    old_operational_step,
                    new_operational_step,
                    old_obsolete,
                    new_obsolete,
                    old_plant_access,
                    new_plant_access,
                    TIMESTAMP,
                    user_id,
                    forename,
                    last_name,
                    old_component_scrap_sync,
                    --R18 Revert
                    new_component_scrap_sync ) --orig
                    --new_component_scrap_sync,
                    --old_ACTUAL_STATUS,
                    --new_ACTUAL_STATUS,
                    --old_PLANNED_STATUS,
                    --new_PLANNED_STATUS)
                    --R18 End
           VALUES ( :OLD.part_no,
                    'D',
                    :OLD.plant,
                    NULL,
                    :OLD.issue_uom,
                    NULL,
                    :OLD.assembly_scrap,
                    NULL,
                    :OLD.component_scrap,
                    NULL,
                    :OLD.lead_time_offset,
                    NULL,
                    :OLD.relevency_to_costing,
                    NULL,
                    :OLD.bulk_material,
                    NULL,
                    :OLD.item_category,
                    NULL,
                    :OLD.issue_location,
                    NULL,
                    :OLD.discontinuation_indicator,
                    NULL,
                    :OLD.discontinuation_date,
                    NULL,
                    :OLD.follow_on_material,
                    NULL,
                    :OLD.commodity_code,
                    NULL,
                    :OLD.operational_step,
                    NULL,
                    :OLD.obsolete,
                    NULL,
                    :OLD.plant_access,
                    NULL,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    iapiGeneral.SESSION.ApplicationUser.Forename,
                    iapiGeneral.SESSION.ApplicationUser.LastName,
                    :OLD.component_scrap_sync,
                    --R18 Revert
                    NULL ); --orig
                    --NULL,
                    --:OLD.ACTUAL_STATUS,
                    --NULL,
                    --:OLD.PLANNED_STATUS,
                    --NULL);
                    --R18   End
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            SQLERRM );
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
END;
/
ALTER TRIGGER "INTERSPC"."TR_PART_PLANT_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PART_PLANT_AI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PART_PLANT_AI" 
   AFTER INSERT
   ON part_plant
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_PART_PLANT_AI';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   lnRetVal := iapiPlantPart.AssignPartToPlant( :NEW.plant,
                                                :NEW.part_no );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   ELSE
      /* To make sure that the export program sp_export_sh exports the header to the intl database
         we have to make sure the timestamp gets modified.
         The problem was that the export program only exports the headers that have been modified since the
         last export.  If during the last export no plant was assigned the specs that had to be
         exported were not exported.  Even after assigning a plant afterwards, the headers were not
         exported anymore */
      BEGIN
         INSERT INTO itsh_h
              VALUES ( :NEW.part_no,
                       SYSDATE );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            UPDATE itsh_h
               SET last_modified_on = SYSDATE
             WHERE part_no = :NEW.part_no;
      END;

      BEGIN
        --R18
         --TODO  NVL(exp, val) has to be applied for each new row to make deletion working..
         --in addition old verifications were like this: --AND   new_plant_access       = NULL.... not correct
         DELETE      ITPRPL_H
               WHERE part_no = :NEW.part_no
                 AND old_plant IS NULL
                 AND new_plant = :NEW.plant
                 AND old_issue_uom IS NULL
                 AND NVL(new_issue_uom, 0) = NVL(:NEW.issue_uom, 0)
                 AND old_assembly_scrap IS NULL
                 AND NVL(new_assembly_scrap, 0) = NVL(:NEW.assembly_scrap, 0)
                 AND old_component_scrap IS NULL
                 AND NVL(new_component_scrap, 0) = NVL(:NEW.component_scrap, 0)
                 AND old_lead_time_offset IS NULL
                 AND NVL(new_lead_time_offset, 0) = NVL(:NEW.lead_time_offset, 0)
                 AND old_relevency_to_costing IS NULL
                 AND NVL(new_relevency_to_costing, 0) = NVL(:NEW.relevency_to_costing, 0)
                 AND OLD_BULK_MATERIAL IS NULL
                 AND NVL(new_bulk_material, 0) = NVL(:NEW.bulk_material, 0)
                 AND old_item_category IS NULL
                 AND NVL(new_item_category, 0) = NVL(:NEW.item_category, 0)
                 AND old_issue_location IS NULL
                 AND NVL(new_issue_location, 0) = NVL(:NEW.issue_location, 0)
                 AND old_discontinuation_indicator IS NULL
                 AND NVL(new_discontinuation_indicator, 0) = NVL(:NEW.discontinuation_indicator, 0)
                 AND old_follow_on_material IS NULL
                 AND NVL(new_follow_on_material, 0) = NVL(:NEW.follow_on_material, 0)
                 AND old_commodity_code IS NULL
                 AND NVL(new_commodity_code, 0) = NVL(:NEW.commodity_code, 0)
                 AND old_operational_step IS NULL
                 AND NVL(new_operational_step, 0) = NVL(:NEW.operational_step, 0)
                 AND old_obsolete IS NULL
                 AND NVL(new_obsolete, 0) = NVL(:NEW.obsolete, 0)
                 AND old_plant_access IS NULL
                 --R18
                 --AND new_plant_access = :NEW.plant_access; --orig
                 AND NVL(new_plant_access, 0) =  NVL(:NEW.plant_access, 0)
                 AND old_component_scrap_sync IS NULL
                 AND NVL(new_component_scrap_sync, 0) = NVL(:NEW.component_scrap_sync , 0);
                 --AND old_ACTUAL_STATUS IS NULL
                 --AND NVL(new_ACTUAL_STATUS, 0) = NVL(:NEW.ACTUAL_STATUS, 0)
                 --AND old_PLANNED_STATUS IS NULL
                 --AND NVL(new_PLANNED_STATUS, 0) = NVL(:NEW.PLANNED_STATUS, 0);
                 --R18 End
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      INSERT INTO itprpl_h
                  ( part_no,
                    action,
                    old_plant,
                    new_plant,
                    old_issue_uom,
                    new_issue_uom,
                    old_assembly_scrap,
                    new_assembly_scrap,
                    old_component_scrap,
                    new_component_scrap,
                    old_lead_time_offset,
                    new_lead_time_offset,
                    old_relevency_to_costing,
                    new_relevency_to_costing,
                    old_bulk_material,
                    new_bulk_material,
                    old_item_category,
                    new_item_category,
                    old_issue_location,
                    new_issue_location,
                    old_discontinuation_indicator,
                    new_discontinuation_indicator,
                    old_discontinuation_date,
                    new_discontinuation_date,
                    old_follow_on_material,
                    new_follow_on_material,
                    old_commodity_code,
                    new_commodity_code,
                    old_operational_step,
                    new_operational_step,
                    old_obsolete,
                    new_obsolete,
--TFS4685 start
--                    old_plant_access,
--                    new_plant_access,
--TFS4685 end
                    TIMESTAMP,
                    user_id,
                    forename,
                    last_name,
                    old_component_scrap_sync,
                    --R18 Revert
                    new_component_scrap_sync ) --orig
                    --new_component_scrap_sync,
                    --old_ACTUAL_STATUS,
                    --new_ACTUAL_STATUS,
                    --old_PLANNED_STATUS,
                    --new_PLANNED_STATUS)
                    --R18 End
           VALUES ( :NEW.part_no,
                    'I',
                    NULL,
                    :NEW.plant,
                    NULL,
                    :NEW.issue_uom,
                    :OLD.assembly_scrap,
                    :NEW.assembly_scrap,
                    NULL,
                    :NEW.component_scrap,
                    NULL,
                    :NEW.lead_time_offset,
                    NULL,
                    :NEW.relevency_to_costing,
                    NULL,
                    :NEW.bulk_material,
                    NULL,
                    :NEW.item_category,
                    NULL,
                    :NEW.issue_location,
                    NULL,
                    :NEW.discontinuation_indicator,
                    NULL,
                    :NEW.discontinuation_date,
                    NULL,
                    :NEW.follow_on_material,
                    NULL,
                    :NEW.commodity_code,
                    NULL,
                    :NEW.operational_step,
                    NULL,
--TFS 4685 oneline
--                    :NEW.obsolete,
                    NULL,
--TFS 4685 oneline
--                    :NEW.plant_access,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    iapiGeneral.SESSION.ApplicationUser.Forename,
                    iapiGeneral.SESSION.ApplicationUser.LastName,
                    NULL,
                    --R18 Revert
                    :NEW.component_scrap_sync ); --orig
                    --:NEW.component_scrap_sync,
                    --NULL,
                    --:NEW.ACTUAL_STATUS,
                    --NULL,
                    --:NEW.PLANNED_STATUS);
                    --R18 End
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            SQLERRM );
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
END;
/
ALTER TRIGGER "INTERSPC"."TR_PART_PLANT_AI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PART_PLANT_BI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PART_PLANT_BI" 
   BEFORE INSERT
   ON PART_PLANT
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_PART_PLANT_BI';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   lnRetVal := iapiPlantPart.GetPlantAccess( :NEW.plant,
                                             :NEW.part_no,
                                             :NEW.plant_access );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_PART_PLANT_BI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PART_PLANT_BU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PART_PLANT_BU" 
   BEFORE UPDATE
   ON PART_PLANT
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_PART_PLANT_BU';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF :OLD.obsolete <> :NEW.obsolete
   THEN
      IF :NEW.obsolete = 1
      THEN
         INSERT INTO itimp_changes
                     ( object_type,
                       item,
                       what,
                       old_value,
                       new_value,
                       TIMESTAMP )
              VALUES ( 'Part/Plant',
                          :NEW.part_no
                       || '/'
                       || :NEW.plant,
                       'Part/Plant obsolete',
                       'Not Obsolete',
                       'Obsolete',
                       SYSDATE );
      ELSE
         INSERT INTO itimp_changes
                     ( object_type,
                       item,
                       what,
                       old_value,
                       new_value,
                       TIMESTAMP )
              VALUES ( 'Part/Plant',
                          :NEW.part_no
                       || '/'
                       || :NEW.plant,
                       'Part/Plant obsolete',
                       'Obsolete',
                       'Not Obsolete',
                       SYSDATE );
      END IF;
   END IF;

   IF :OLD.plant <> :NEW.plant
   THEN
      lnRetval := iapiPlantPart.GetPlantAccess( :NEW.plant,
                                                :NEW.part_no,
                                                :NEW.plant_access );

      IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.logError( lsSource,
                               '',
                               iapiGeneral.getLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_PART_PLANT_BU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PART_PLANT_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PART_PLANT_OU" 
   AFTER UPDATE
   ON part_plant
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_PART_PLANT_OU';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF :OLD.plant <> :NEW.plant
   THEN
      lnRetVal := iapiPlantPart.RemovePartFromPlant( :OLD.plant,
                                                     :OLD.part_no );

      IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.logError( lsSource,
                               '',
                               iapiGeneral.getLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;

      lnRetVal := iapiPlantPart.AssignPartToPlant( :NEW.plant,
                                                   :NEW.part_no );

      IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.logError( lsSource,
                               '',
                               iapiGeneral.getLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;
   END IF;

--TODO  NVL(exp, val)  has to be applied for each row of condiiton to make working..
--in addition old verifications were like this: OR :OLD.plant_access <> :NEW.plant_access.... not correct
   IF      NVL(:OLD.issue_uom, 0) <> NVL(:NEW.issue_uom, 0)
      OR NVL(:OLD.assembly_scrap, 0) <> NVL(:NEW.assembly_scrap, 0)
      OR NVL(:OLD.component_scrap, 0) <> NVL(:NEW.component_scrap, 0)
      OR NVL(:OLD.lead_time_offset, 0) <> NVL(:NEW.lead_time_offset, 0)
      OR NVL(:OLD.relevency_to_costing, 0) <> NVL(:NEW.relevency_to_costing, 0)
      OR NVL(:OLD.bulk_material, 0) <> NVL(:NEW.bulk_material, 0)
      OR NVL(:OLD.item_category, 0) <> NVL(:NEW.item_category, 0)
      OR NVL(:OLD.issue_location, 0) <> NVL(:NEW.issue_location, 0)
      OR NVL(:OLD.discontinuation_indicator, 0) <> NVL(:NEW.discontinuation_indicator, 0)
      --OR NVL(:OLD.discontinuation_date, 0) <> NVL(:NEW.discontinuation_date, 0)
      OR NVL(:OLD.follow_on_material, 0) <> NVL(:NEW.follow_on_material, 0)
      OR NVL(:OLD.commodity_code, 0) <> NVL(:NEW.commodity_code, 0)
      OR NVL(:OLD.operational_step, 0) <> NVL(:NEW.operational_step, 0)
      OR NVL(:OLD.obsolete, 0) <> NVL(:NEW.obsolete, 0)
      OR NVL(:OLD.plant_access, 0) <> NVL(:NEW.plant_access, 0)
      --R18 Revert
      OR NVL(:OLD.COMPONENT_SCRAP_SYNC, 0) <> NVL(:NEW.COMPONENT_SCRAP_SYNC, 0)
      --OR NVL(:OLD.ACTUAL_STATUS, 0) <> NVL(:NEW.ACTUAL_STATUS, 0)
      --OR NVL(:OLD.PLANNED_STATUS, 0) <> NVL(:NEW.PLANNED_STATUS, 0)
      --R18 End
   THEN
      INSERT INTO ITPRPL_H
                 ( part_no,
                   action,
                   old_plant,
                   new_plant,
                   old_issue_uom,
                   new_issue_uom,
                   old_assembly_scrap,
                   new_assembly_scrap,
                   old_component_scrap,
                   new_component_scrap,
                   old_lead_time_offset,
                   new_lead_time_offset,
                   old_relevency_to_costing,
                   new_relevency_to_costing,
                   old_bulk_material,
                   new_bulk_material,
                   old_item_category,
                   new_item_category,
                   old_issue_location,
                   new_issue_location,
                   old_discontinuation_indicator,
                   new_discontinuation_indicator,
                   old_discontinuation_date,
                   new_discontinuation_date,
                   old_follow_on_material,
                   new_follow_on_material,
                   old_commodity_code,
                   new_commodity_code,
                   old_operational_step,
                   new_operational_step,
                   old_obsolete,
                   new_obsolete,
                   old_plant_access,
                   new_plant_access,
                   TIMESTAMP,
                   user_id,
                   forename,
                   last_name,
                   old_component_scrap_sync,
                   --R18 Revert
                   new_component_scrap_sync ) --orig
                   --new_component_scrap_sync,
                   --old_ACTUAL_STATUS,
                   --new_ACTUAL_STATUS,
                   --old_PLANNED_STATUS,
                   --new_PLANNED_STATUS)
            --R18 End
          VALUES ( :OLD.part_no,
                   'U',
                   :OLD.plant,
                   :NEW.plant,
                   :OLD.issue_uom,
                   :NEW.issue_uom,
                   :OLD.assembly_scrap,
                   :NEW.assembly_scrap,
                   :OLD.component_scrap,
                   :NEW.component_scrap,
                   :OLD.lead_time_offset,
                   :NEW.lead_time_offset,
                   :OLD.relevency_to_costing,
                   :NEW.relevency_to_costing,
                   :OLD.bulk_material,
                   :NEW.bulk_material,
                   :OLD.item_category,
                   :NEW.item_category,
                   :OLD.issue_location,
                   :NEW.issue_location,
                   :OLD.discontinuation_indicator,
                   :NEW.discontinuation_indicator,
                   :OLD.discontinuation_date,
                   :NEW.discontinuation_date,
                   :OLD.follow_on_material,
                   :NEW.follow_on_material,
                   :OLD.commodity_code,
                   :NEW.commodity_code,
                   :OLD.operational_step,
                   :NEW.operational_step,
                   :OLD.obsolete,
                   :NEW.obsolete,
                   :OLD.plant_access,
                   :NEW.plant_access,
                   SYSDATE,
                   iapiGeneral.SESSION.ApplicationUser.UserId,
                   iapiGeneral.SESSION.ApplicationUser.Forename,
                   iapiGeneral.SESSION.ApplicationUser.LastName,
                   :OLD.component_scrap_sync,
                    --R18 Revert
                    :NEW.component_scrap_sync ); --orig
                    --:NEW.component_scrap_sync,
                    --:OLD.ACTUAL_STATUS,
                    --:NEW.ACTUAL_STATUS,
                    --:OLD.PLANNED_STATUS,
                    --:NEW.PLANNED_STATUS);
                    --R18 End
    END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            SQLERRM );
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );


END;
/
ALTER TRIGGER "INTERSPC"."TR_PART_PLANT_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PLANT_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PLANT_OU" AFTER UPDATE ON PLANT REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 DECLARE
BEGIN
    IF :old.description <> :new.description THEN
       INSERT INTO itimp_changes (object_type,item,what,old_value,new_value,timestamp)
       VALUES ('Plant',:old.plant,'Description',:old.description,:new.description,SYSDATE);
	END IF;
null;
END;

/
ALTER TRIGGER "INTERSPC"."TR_PLANT_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PRICE_TYPE_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PRICE_TYPE_OD" AFTER DELETE ON PRICE_TYPE REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW

 DECLARE
BEGIN
DELETE part_cost WHERE period = :old.period;
EXCEPTION
        WHEN OTHERS THEN
                null;
END;

/
ALTER TRIGGER "INTERSPC"."TR_PRICE_TYPE_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PROCESS_LINE_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PROCESS_LINE_OI" 
   BEFORE INSERT
   ON PROCESS_LINE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_PROCESS_LINE_OI';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE PROCESS_LINE_H
         SET max_rev = 0
       WHERE PLANT = :NEW.PLANT
         AND LINE = :NEW.LINE
         AND CONFIGURATION = :NEW.CONFIGURATION;

      INSERT INTO PROCESS_LINE_H
                  ( plant,
                    line,
                    configuration,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.PLANT,
                    :NEW.LINE,
                    :NEW.CONFIGURATION,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_PROCESS_LINE_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PROCESS_LINE_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PROCESS_LINE_OU" 
   AFTER UPDATE OF description, status
   ON PROCESS_LINE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_PROCESS_LINE_OU';
   lnRetVal                      iapiType.ErrorNum_Type;
   l_next_val                    NUMBER;
   lnRevision                    iapiType.Revision_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.description <> :NEW.description
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO lnRevision
        FROM PROCESS_LINE_H
       WHERE PLANT = :NEW.PLANT
         AND LINE = :NEW.LINE
         AND CONFIGURATION = :NEW.CONFIGURATION
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE PROCESS_LINE_H
         SET max_rev = 0
       WHERE PLANT = :NEW.PLANT
         AND LINE = :NEW.LINE
         AND CONFIGURATION = :NEW.CONFIGURATION
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM PROCESS_LINE_H
       WHERE PLANT = :NEW.PLANT
         AND LINE = :NEW.LINE
         AND CONFIGURATION = :NEW.CONFIGURATION;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO PROCESS_LINE_H
                  ( PLANT,
                    LINE,
                    CONFIGURATION,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.PLANT,
                    :NEW.LINE,
                    :NEW.CONFIGURATION,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO PROCESS_LINE_H
                  ( PLANT,
                    LINE,
                    CONFIGURATION,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.PLANT,
                :NEW.LINE,
                :NEW.CONFIGURATION,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                1
           FROM PROCESS_LINE_H
          WHERE PLANT = :NEW.PLANT
            AND LINE = :NEW.LINE
            AND CONFIGURATION = :NEW.CONFIGURATION
            AND revision = lnRevision
            AND lang_id <> 1;
   END IF;
--    IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
--                   AND :NEW.intl = '0' )
--             OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
--       AND :OLD.STATUS <> :NEW.STATUS
--       AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
--    THEN
--       INSERT INTO ITENSSLOG
--                   ( en_tp,
--                     en_id,
--                     status_change_date,
--                     user_id,
--                     status )
--            VALUES ( 'pl',
--                     :NEW.PROCESS_LINE,
--                     SYSDATE,
--                     iapiGeneral.SESSION.ApplicationUser.UserId,
--                     :NEW.status );
--    END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_PROCESS_LINE_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PROCESS_LINE_STAGE_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PROCESS_LINE_STAGE_AD" 
BEFORE DELETE
   ON PROCESS_LINE_STAGE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Process_Line_Stage_Ad';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN


      INSERT INTO PROCESS_LINE_STAGE_H
                  ( PLANT ,
					LINE  ,
					CONFIGURATION ,
					STAGE ,
					LAST_MODIFIED_ON ,
					LAST_MODIFIED_BY ,
					SEQUENCE_NO,
					RECIRCULATE_TO,
					TEXT_TYPE,
					DISPLAY_FORMAT,
					INTL ,
					ACTION
				  )

            VALUES (:OLD.PLANT,
                    :OLD.LINE,
                    :OLD.CONFIGURATION,
                    :OLD.STAGE,
					SYSDATE,
					iapiGeneral.SESSION.ApplicationUser.UserId,
					:OLD.SEQUENCE_NO,
					:OLD.RECIRCULATE_TO,
					:OLD.TEXT_TYPE,
					:OLD.DISPLAY_FORMAT,
					:OLD.intl,
                    'D');
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_PROCESS_LINE_STAGE_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PROCESS_LINE_STAGE_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PROCESS_LINE_STAGE_OI" 
   BEFORE INSERT
   ON PROCESS_LINE_STAGE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Process_Line_Stage_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN



      INSERT INTO PROCESS_LINE_STAGE_H
                  ( PLANT ,
					LINE  ,
					CONFIGURATION ,
					STAGE ,
					LAST_MODIFIED_ON ,
					LAST_MODIFIED_BY ,
					SEQUENCE_NO,
					RECIRCULATE_TO,
					TEXT_TYPE,
					DISPLAY_FORMAT,
					INTL ,
					ACTION
				  )

            VALUES (:NEW.PLANT,
                    :NEW.LINE,
                    :NEW.CONFIGURATION,
                    :NEW.STAGE,
					SYSDATE,
					iapiGeneral.SESSION.ApplicationUser.UserId,
					:NEW.SEQUENCE_NO,
					:NEW.RECIRCULATE_TO,
					:NEW.TEXT_TYPE,
					:NEW.DISPLAY_FORMAT,
					:NEW.intl,
                    'I');
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_PROCESS_LINE_STAGE_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PROCESS_LINE_STAGE_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PROCESS_LINE_STAGE_OU" 
   BEFORE UPDATE
   ON PROCESS_LINE_STAGE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Process_Line_Stage_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN

      INSERT INTO PROCESS_LINE_STAGE_H
                  ( PLANT ,
					LINE  ,
					CONFIGURATION ,
					STAGE ,
					LAST_MODIFIED_ON ,
					LAST_MODIFIED_BY ,
					SEQUENCE_NO,
					RECIRCULATE_TO,
					TEXT_TYPE,
					DISPLAY_FORMAT,
					INTL ,
					ACTION
				  )

            VALUES (:NEW.PLANT,
                    :NEW.LINE,
                    :NEW.CONFIGURATION,
                    :NEW.STAGE,
					SYSDATE,
					iapiGeneral.SESSION.ApplicationUser.UserId,
					:NEW.SEQUENCE_NO,
					:NEW.RECIRCULATE_TO,
					:NEW.TEXT_TYPE,
					:NEW.DISPLAY_FORMAT,
					:NEW.intl,
                    'U');
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_PROCESS_LINE_STAGE_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PROP_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PROP_OI" 
   BEFORE INSERT
   ON PROPERTY
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorTextAndLoginfo( 'TR_PROP_OU',
                                                      '',
                                                      iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_PROP_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE property_h
         SET max_rev = 0
       WHERE property = :NEW.property;

      INSERT INTO PROPERTY_H
                  ( property,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.property,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_PROP_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PROP_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PROP_OU" 
   AFTER UPDATE OF description, status
   ON PROPERTY
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
---------------------------------------------------------------------------
-- $Workfile: TR_PROP_OU.sql $
--     Type:  Trigger creation script
----------------------------------------------------------------------------
--   $Author: evoVaLa3 $
-- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
--  $Modtime: 2014-May-05 12:00 $
--   Project: speCX development
----------------------------------------------------------------------------
--  Abstract:
----------------------------------------------------------------------------
DECLARE
   l_next_val                    NUMBER;
   l_bubble                      VARCHAR2( 1000 );
   l_revision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorTextAndLoginfo( 'TR_PROP_OU',
                                                      '',
                                                      iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_PROP_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.description <> :NEW.description
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM property_h
       WHERE property = :NEW.property
         AND lang_id = 1
         AND max_rev = 1;

      UPDATE property_h
         SET max_rev = 0
       WHERE property = :NEW.property
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM PROPERTY_H
       WHERE property = :NEW.property;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO PROPERTY_H
                  ( property,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.property,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO PROPERTY_H
                  ( property,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.property,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                1
           FROM property_h
          WHERE property = :NEW.property
            AND revision = l_revision
            AND lang_id <> 1;

      SELECT MAX( revision )
        INTO l_revision
        FROM property_b
       WHERE revision < l_next_val
         AND property = :NEW.property
         AND lang_id = 1;

      IF l_revision IS NOT NULL
      THEN
         SELECT bubble
           INTO l_bubble
           FROM property_b
          WHERE revision = l_revision
            AND lang_id = 1
            AND property = :NEW.property;

         INSERT INTO property_b
                     ( property,
                       revision,
                       lang_id,
                       bubble,
                       last_modified_on,
                       last_modified_by )
              VALUES ( :NEW.property,
                       l_next_val,
                       1,
                       l_bubble,
                       SYSDATE,
                       iapiGeneral.SESSION.ApplicationUser.UserId );
      END IF;
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'sp',
                    :NEW.property,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );

      NULL;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_PROP_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PROPERTY_GROUP_LIST_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PROPERTY_GROUP_LIST_AD" 
   BEFORE DELETE
   ON PROPERTY_GROUP_LIST
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Property_Group_List_Ad';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO PROPERTY_GROUP_LIST_H
                  ( PROPERTY_GROUP,
                    PROPERTY,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl,
                    mandatory )
           VALUES ( :OLD.PROPERTY_GROUP,
                    :OLD.PROPERTY,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    :OLD.intl,
                    :OLD.mandatory );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_PROPERTY_GROUP_LIST_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PROPERTY_GROUP_LIST_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PROPERTY_GROUP_LIST_OI" 
   BEFORE INSERT
   ON PROPERTY_GROUP_LIST
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Property_Group_List_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO property_group_list_h
                  ( property_group,
                    property,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl,
                    mandatory )
           VALUES ( :NEW.property_group,
                    :NEW.property,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl,
                    :NEW.mandatory );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_PROPERTY_GROUP_LIST_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PROPERTY_GROUP_LIST_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PROPERTY_GROUP_LIST_OU" 
   BEFORE UPDATE
   ON PROPERTY_GROUP_LIST
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Property_Group_List_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO property_group_list_h
                  ( property_group,
                    property,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl,
                    mandatory )
           VALUES ( :NEW.property_group,
                    :NEW.property,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl,
                    :NEW.mandatory );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_PROPERTY_GROUP_LIST_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PROPG_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PROPG_OI" 
   BEFORE INSERT
   ON PROPERTY_GROUP
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Propg_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE property_group_h
         SET max_rev = 0
       WHERE property_group = :NEW.property_group;

      INSERT INTO PROPERTY_GROUP_H
                  ( property_group,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev,
                    pg_type )
           VALUES ( :NEW.property_group,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1,
                    :NEW.pg_type );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_PROPG_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_PROPG_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_PROPG_OU" 
   AFTER UPDATE OF description, status, pg_type
   ON PROPERTY_GROUP
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_bubble                      VARCHAR2( 1000 );
   l_revision                    NUMBER;
   lsSource                      iapiType.Source_Type := 'Tr_Propg_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND ( :OLD.description <> :NEW.description )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT MAX( revision )
        INTO l_revision
        FROM property_group_h
       WHERE property_group = :NEW.property_group
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE property_group_h
         SET max_rev = 0
       WHERE property_group = :NEW.property_group
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM PROPERTY_GROUP_H
       WHERE property_group = :NEW.property_group;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO PROPERTY_GROUP_H
                  ( property_group,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    pg_type,
                    max_rev )
           VALUES ( :NEW.property_group,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.pg_type,
                    1 );

      INSERT INTO PROPERTY_GROUP_H
                  ( property_group,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    pg_type,
                    max_rev )
         SELECT :NEW.property_group,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                pg_type,
                1
           FROM property_group_h
          WHERE property_group = :NEW.property_group
            AND revision = l_revision
            AND lang_id <> 1;

      SELECT MAX( revision )
        INTO l_revision
        FROM property_group_b
       WHERE revision < l_next_val
         AND property_group = :NEW.property_group
         AND lang_id = 1;

      IF l_revision IS NOT NULL
      THEN
         SELECT bubble
           INTO l_bubble
           FROM property_group_b
          WHERE revision = l_revision
            AND lang_id = 1
            AND property_group = :NEW.property_group;

         INSERT INTO property_group_b
                     ( property_group,
                       revision,
                       lang_id,
                       bubble,
                       last_modified_on,
                       last_modified_by )
              VALUES ( :NEW.property_group,
                       l_next_val,
                       1,
                       l_bubble,
                       SYSDATE,
                       iapiGeneral.SESSION.ApplicationUser.UserId );
      END IF;
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'pg',
                    :NEW.property_group,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND ( :OLD.pg_type <> :NEW.pg_type )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE property_group_h
         SET pg_type = :NEW.pg_type,
             last_modified_by = iapiGeneral.SESSION.ApplicationUser.UserId,
             last_modified_on = SYSDATE
       WHERE property_group = :NEW.property_group
         AND max_rev = 1;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_PROPG_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_REFERENCE_TEXT_BU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_REFERENCE_TEXT_BU" 
BEFORE UPDATE
ON REFERENCE_TEXT
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE

BEGIN
   :NEW.LAST_MODIFIED_ON := SYSDATE;
   :NEW.LAST_EDITED_BY := USER;
END tr_last_modified;
/
ALTER TRIGGER "INTERSPC"."TR_REFERENCE_TEXT_BU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SECTION_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SECTION_OI" 
   BEFORE INSERT
   ON SECTION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText(iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_SECTION_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE section_h
         SET max_rev = 0
       WHERE section_id = :NEW.section_id;

      INSERT INTO SECTION_H
                  ( section_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.section_id,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_SECTION_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SECTION_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SECTION_OU" 
   AFTER UPDATE OF description, status
   ON SECTION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_bubble                      VARCHAR2( 1000 );
   l_revision                    NUMBER;
   lsSource                      iapiType.Source_Type := 'Tr_Section_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.description <> :NEW.description
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM section_h
       WHERE section_id = :NEW.section_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE section_h
         SET max_rev = 0
       WHERE section_id = :NEW.section_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM section_h
       WHERE section_id = :NEW.section_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO SECTION_H
                  ( section_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.section_id,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO SECTION_H
                  ( section_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.section_id,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                1
           FROM section_h
          WHERE section_id = :NEW.section_id
            AND revision = l_revision
            AND lang_id <> 1;

      SELECT MAX( revision )
        INTO l_revision
        FROM section_b
       WHERE revision < l_next_val
         AND section_id = :NEW.section_id
         AND lang_id = 1;

      IF l_revision IS NOT NULL
      THEN
         SELECT bubble
           INTO l_bubble
           FROM section_b
          WHERE revision = l_revision
            AND lang_id = 1
            AND section_id = :NEW.section_id;

         INSERT INTO section_b
                     ( section_id,
                       revision,
                       lang_id,
                       bubble,
                       last_modified_on,
                       last_modified_by )
              VALUES ( :NEW.section_id,
                       l_next_val,
                       1,
                       l_bubble,
                       SYSDATE,
                       iapiGeneral.SESSION.ApplicationUser.UserId );
      END IF;
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'sc',
                    :NEW.section_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_SECTION_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SHKW_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SHKW_OD" 
   AFTER DELETE
   ON SPECIFICATION_KW
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_owner                       specification_header.owner%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Shkw_Od';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   UPDATE itsh_h
      SET last_modified_on = SYSDATE
    WHERE part_no = :OLD.part_no;

   SELECT MAX( owner )
     INTO l_owner
     FROM specification_header
    WHERE part_no = :OLD.part_no;

   IF l_owner = iapiGeneral.SESSION.DATABASE.Owner
   THEN
      INSERT INTO specification_kw_h
                  ( part_no,
                    kw_id,
                    kw_value,
                    last_modified_on,
                    last_modified_by,
                    action,
                    forename,
                    last_name )
           VALUES ( :OLD.part_no,
                    :OLD.kw_id,
                    :OLD.kw_value,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    iapiGeneral.SESSION.ApplicationUser.Forename,
                    iapiGeneral.SESSION.ApplicationUser.LastName );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_SHKW_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SHKW_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SHKW_OI" 
   AFTER INSERT
   ON SPECIFICATION_KW
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_owner                       specification_header.owner%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Shkw_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   BEGIN
      INSERT INTO itsh_h
                  ( part_no,
                    last_modified_on )
           VALUES ( :NEW.part_no,
                    SYSDATE );
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         UPDATE itsh_h
            SET last_modified_on = SYSDATE
          WHERE part_no = :NEW.part_no;
   END;

   SELECT MAX( owner )
     INTO l_owner
     FROM specification_header
    WHERE part_no = :NEW.part_no;

   IF l_owner = iapiGeneral.SESSION.DATABASE.Owner
   THEN
      INSERT INTO specification_kw_h
                  ( part_no,
                    kw_id,
                    kw_value,
                    last_modified_on,
                    last_modified_by,
                    action,
                    forename,
                    last_name )
           VALUES ( :NEW.part_no,
                    :NEW.kw_id,
                    :NEW.kw_value,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    iapiGeneral.SESSION.ApplicationUser.Forename,
                    iapiGeneral.SESSION.ApplicationUser.LastName );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_SHKW_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SHKW_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SHKW_OU" 
   AFTER UPDATE
   ON SPECIFICATION_KW
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_owner                       specification_header.owner%TYPE;
   lsSource                      iapiType.Source_Type := 'Tr_Shkw_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   UPDATE itsh_h
      SET last_modified_on = SYSDATE
    WHERE part_no = :OLD.part_no;

   SELECT MAX( owner )
     INTO l_owner
     FROM specification_header
    WHERE part_no = :OLD.part_no;

   IF l_owner = iapiGeneral.SESSION.DATABASE.Owner
   THEN
      INSERT INTO specification_kw_h
                  ( part_no,
                    kw_id,
                    kw_value,
                    last_modified_on,
                    last_modified_by,
                    action,
                    forename,
                    last_name )
           VALUES ( :NEW.part_no,
                    :OLD.kw_id,
                    :OLD.kw_value,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    iapiGeneral.SESSION.ApplicationUser.Forename,
                    iapiGeneral.SESSION.ApplicationUser.LastName );

      INSERT INTO specification_kw_h
                  ( part_no,
                    kw_id,
                    kw_value,
                    last_modified_on,
                    last_modified_by,
                    action,
                    forename,
                    last_name )
           VALUES ( :NEW.part_no,
                    :NEW.kw_id,
                    :NEW.kw_value,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    iapiGeneral.SESSION.ApplicationUser.Forename,
                    iapiGeneral.SESSION.ApplicationUser.LastName );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_SHKW_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPAHS_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPAHS_AD" 
   AFTER DELETE
   ON attached_specification
   FOR EACH ROW
DECLARE
   lsStatus                      iapiType.StatusType_Type;
   lsSource                      iapiType.Source_Type := 'Tr_Spahs_Ad';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT st.status_type
     INTO lsStatus
     FROM specification_header sh,
          status st
    WHERE part_no = :OLD.part_no
      AND revision = :OLD.revision
      AND sh.status = st.status;

   IF lsStatus = iapiConstant.STATUSTYPE_DEVELOPMENT
   THEN
      lnRetVal := iapiSpecificationSection.CreateSectionHistory( :OLD.part_no,
                                                                 :OLD.revision,
                                                                 :OLD.section_id,
                                                                 :OLD.sub_section_id );

      IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.LogError( lsSource,
                               '',
                               iapiGeneral.GetLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            SQLERRM );
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
END;
/
ALTER TRIGGER "INTERSPC"."TR_SPAHS_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPAHS_AI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPAHS_AI" 
   AFTER INSERT
   ON attached_specification
   FOR EACH ROW
DECLARE
   lsStatus                      iapiType.StatusType_Type;
   lsSource                      iapiType.Source_Type := 'Tr_Spahs_Ai';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   SELECT st.status_type
     INTO lsStatus
     FROM specification_header sh,
          status st
    WHERE part_no = :NEW.part_no
      AND revision = :NEW.revision
      AND sh.status = st.status;

   IF lsStatus = iapiConstant.STATUSTYPE_DEVELOPMENT
   THEN
      lnRetVal := iapiSpecificationSection.CreateSectionHistory( :NEW.part_no,
                                                                 :NEW.revision,
                                                                 :NEW.section_id,
                                                                 :NEW.sub_section_id );

      IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.LogError( lsSource,
                               '',
                               iapiGeneral.GetLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            SQLERRM );
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
END;
/
ALTER TRIGGER "INTERSPC"."TR_SPAHS_AI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPAHS_AU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPAHS_AU" 
--IS1178 End
   AFTER UPDATE
   --IS1178 Start
   --ON SPECIFICATION_SECTION --old
   ON ATTACHED_SPECIFICATION
   --IS1178 End
   FOR EACH ROW
DECLARE
   lsStatus                      iapiType.StatusType_Type;
   --IS1178 Start
   --lsSource                      iapiType.Source_Type := 'Tr_Spchs_Au'; --orig
   lsSource                      iapiType.Source_Type := 'Tr_Spahs_Au';
   --IS1178 End
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   SELECT st.status_type
     INTO lsStatus
     FROM specification_header sh,
          status st
    WHERE part_no = :OLD.part_no
      AND revision = :OLD.revision
      AND sh.status = st.status;

   IF (
          (:OLD.part_no <> :NEW.part_no) OR
          (:OLD.revision <> :NEW.revision) OR
          (:OLD.section_id <> :NEW.section_id) OR
          (:OLD.sub_section_id <> :NEW.sub_section_id)
      )
   THEN

       IF lsStatus = iapiConstant.STATUSTYPE_DEVELOPMENT
       THEN
          lnRetVal := iapiSpecificationSection.CreateSectionHistory( :OLD.part_no,
                                                                     :OLD.revision,
                                                                     :OLD.section_id,
                                                                     :OLD.sub_section_id );

          IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
          THEN
             iapiGeneral.LogError( lsSource,
                                   '',
                                   iapiGeneral.GetLastErrorText( ) );
             RAISE_APPLICATION_ERROR( -20000,
                                      iapiGeneral.GetLastErrorText( ) );
          END IF;
       END IF;

   END IF;

EXCEPTION
   WHEN OTHERS
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            SQLERRM );
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
END;
/
ALTER TRIGGER "INTERSPC"."TR_SPAHS_AU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPCHS_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPCHS_AD" 
   AFTER DELETE
   ON specification_section
   FOR EACH ROW
DECLARE
   lsStatus                      iapiType.StatusType_Type;
   lsSource                      iapiType.Source_Type := 'Tr_Spchs_Ad';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT st.status_type
     INTO lsStatus
     FROM specification_header sh,
          status st
    WHERE part_no = :OLD.part_no
      AND revision = :OLD.revision
      AND sh.status = st.status;

   IF lsStatus = iapiConstant.STATUSTYPE_DEVELOPMENT
   THEN
      lnRetVal := iapiSpecificationSection.CreateSectionHistory( :OLD.part_no,
                                                                 :OLD.revision,
                                                                 :OLD.section_id,
                                                                 :OLD.sub_section_id );

      IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.LogError( lsSource,
                               '',
                               iapiGeneral.GetLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            SQLERRM );
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
END;
/
ALTER TRIGGER "INTERSPC"."TR_SPCHS_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPCHS_AI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPCHS_AI" 
   AFTER INSERT
   ON specification_section
   FOR EACH ROW
DECLARE
   lsStatus                      iapiType.StatusType_Type;
   lsSource                      iapiType.Source_Type := 'Tr_Spchs_Ai';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   SELECT st.status_type
     INTO lsStatus
     FROM specification_header sh,
          status st
    WHERE part_no = :NEW.part_no
      AND revision = :NEW.revision
      AND sh.status = st.status;

   IF lsStatus = iapiConstant.STATUSTYPE_DEVELOPMENT
   THEN
      lnRetVal := iapiSpecificationSection.CreateSectionHistory( :NEW.part_no,
                                                                 :NEW.revision,
                                                                 :NEW.section_id,
                                                                 :NEW.sub_section_id );

      IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.LogError( lsSource,
                               '',
                               iapiGeneral.GetLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            SQLERRM );
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
END;
/
ALTER TRIGGER "INTERSPC"."TR_SPCHS_AI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPCHS_AU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPCHS_AU" 
   AFTER UPDATE
   ON SPECIFICATION_SECTION    FOR EACH ROW
DECLARE
   lsStatus                      iapiType.StatusType_Type;
   lsSource                      iapiType.Source_Type := 'Tr_Spchs_Au';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   SELECT st.status_type
     INTO lsStatus
     FROM specification_header sh,
          status st
    WHERE part_no = :OLD.part_no
      AND revision = :OLD.revision
      AND sh.status = st.status;

   IF (
          (:OLD.part_no <> :NEW.part_no) OR
          (:OLD.revision <> :NEW.revision) OR
          (:OLD.section_id <> :NEW.section_id) OR
          (:OLD.sub_section_id <> :NEW.sub_section_id)
      )
   THEN

       IF lsStatus = iapiConstant.STATUSTYPE_DEVELOPMENT
       THEN
       --AP01058362 --AP01033131 Start
       IF (iapiGeneral.SESSION.DATABASE.CreateSectionHistory = TRUE)
       THEN
       --AP01058362 --AP01033131 End
          lnRetVal := iapiSpecificationSection.CreateSectionHistory( :OLD.part_no,
                                                                     :OLD.revision,
                                                                     :OLD.section_id,
                                                                     :OLD.sub_section_id );
       --AP01058362 --AP01033131 Start
       END IF;
       --AP01058362 --AP01033131 End

          IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
          THEN
             iapiGeneral.LogError( lsSource,
                                   '',
                                   iapiGeneral.GetLastErrorText( ) );
             RAISE_APPLICATION_ERROR( -20000,
                                      iapiGeneral.GetLastErrorText( ) );
          END IF;
       END IF;

   END IF;

EXCEPTION
   WHEN OTHERS
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            SQLERRM );
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
END;
/
ALTER TRIGGER "INTERSPC"."TR_SPCHS_AU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPEC_ACCESS_GROUP_CHANGE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPEC_ACCESS_GROUP_CHANGE" 
   AFTER UPDATE OF ACCESS_GROUP
   ON SPECIFICATION_HEADER
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_SPEC_ACCESS_GROUP_CHANGE';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF ( :NEW.ACCESS_GROUP <> :OLD.ACCESS_GROUP )
   THEN
      lnRetVal :=
         iapiEvent.SinkEvent( iapiConstant.SpecAccessGroupChanged,
                                 :NEW.part_no
                              || '|'
                              || TO_CHAR( :NEW.revision )
                              || '|'
                              || TO_CHAR( :OLD.ACCESS_GROUP )
                              || '|'
                              || F_Ac_Descr( :OLD.ACCESS_GROUP )
                              || '|'
                              || F_Ag_Descr( :OLD.ACCESS_GROUP )
                              || '|'
                              || TO_CHAR( :NEW.ACCESS_GROUP )
                              || '|'
                              || F_Ac_Descr( :NEW.ACCESS_GROUP )
                              || '|'
                              || F_Ag_Descr( :NEW.ACCESS_GROUP ) );

      IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.LogError( lsSource,
                               '',
                               iapiGeneral.GetLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_SPEC_ACCESS_GROUP_CHANGE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPEC_CLASS3_CHANGE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPEC_CLASS3_CHANGE" 
   AFTER UPDATE OF CLASS3_ID
   ON SPECIFICATION_HEADER
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Spec_Class3_Change';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF ( :NEW.class3_id <> :OLD.class3_id )
   THEN
      lnRetVal :=
         iapiEvent.SinkEvent( iapiConstant.SpecSpecTypeChanged,
                                 :NEW.part_no
                              || '|'
                              || TO_CHAR( :NEW.revision )
                              || '|'
                              || TO_CHAR( :OLD.class3_id )
                              || '|'
                              || f_class3_descr( :OLD.class3_id )
                              || '|'
                              || TO_CHAR( :NEW.class3_id )
                              || '|'
                              || f_class3_descr( :NEW.class3_id ) );
   END IF;

   IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_SPEC_CLASS3_CHANGE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPEC_FRAME_CHANGE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPEC_FRAME_CHANGE" 
   AFTER UPDATE OF FRAME_ID, FRAME_REV
   ON SPECIFICATION_HEADER
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Spec_Frame_Change';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF (    :NEW.frame_id <> :OLD.frame_id
        OR :NEW.frame_rev <> :OLD.frame_rev )
   THEN
      lnRetVal :=
         iapiEvent.SinkEvent( iapiConstant.SpecFrameChanged,
                                 :NEW.part_no
                              || '|'
                              || TO_CHAR( :NEW.revision )
                              || '|'
                              || TO_CHAR( :OLD.frame_id )
                              || '|'
                              || TO_CHAR( :OLD.frame_rev*100 )
                              || '|'
                              || TO_CHAR( :OLD.frame_owner )
                              || '|'
                              || f_owner_descr( :OLD.frame_owner )
                              || '|'
                              || TO_CHAR( :NEW.frame_id )
                              || '|'
                              || TO_CHAR( :NEW.frame_rev*100 )
                              || '|'
                              || TO_CHAR( :NEW.frame_owner )
                              || '|'
                              || f_owner_descr( :NEW.frame_owner ) );

      IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.LogError( lsSource,
                               '',
                               iapiGeneral.GetLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_SPEC_FRAME_CHANGE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPEC_NEW
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPEC_NEW" 
   AFTER INSERT
   ON SPECIFICATION_HEADER
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Spec_New';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   lnRetVal := iapiEvent.SinkEvent( iapiConstant.SpecCreated,
                                       :NEW.part_no
                                    || '|'
                                    || TO_CHAR( :NEW.revision ) );

   IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_SPEC_NEW" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPEC_STATUS_CHANGE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPEC_STATUS_CHANGE" 
   AFTER UPDATE OF STATUS
   ON SPECIFICATION_HEADER
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Spec_Status_Change';
   lnRetVal                      iapiType.ErrorNum_Type;
   lnCount                       iapiType.NumVal_Type;
   lsNewStatusType               iapiType.StatusType_Type;
   lsOldStatusType               iapiType.StatusType_Type;
BEGIN
   IF ( :NEW.status <> :OLD.status )
   THEN
      SELECT COUNT( * )
        INTO lnCount
        FROM status
       WHERE status = :OLD.Status;

      IF lnCount > 0
      THEN
         SELECT status_type
           INTO lsOldStatusType
           FROM status
          WHERE status = :OLD.Status;
      END IF;

      SELECT COUNT( * )
        INTO lnCount
        FROM status
       WHERE status = :NEW.Status;

      IF lnCount > 0
      THEN
         SELECT status_type
           INTO lsNewStatusType
           FROM status
          WHERE status = :NEW.Status;
      END IF;

      lnRetVal :=
         iapiEvent.SinkEvent( iapiConstant.SpecStatusChanged,
                                 :NEW.part_no
                              || '|'
                              || TO_CHAR( :NEW.revision )
                              || '|'
                              || TO_CHAR( :OLD.status )
                              || '|'
                              || f_ss_descr( :OLD.status )
                              || '|'
                              || TO_CHAR( :NEW.status )
                              || '|'
                              || f_ss_descr( :NEW.status )
                              || '|'
                              || lsOldStatusType
                              || '|'
                              || lsNewStatusType );

      IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.LogError( lsSource,
                               '',
                               iapiGeneral.GetLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_SPEC_STATUS_CHANGE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPECIFICATION_HEADER_BU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPECIFICATION_HEADER_BU" 
   BEFORE UPDATE
   ON SPECIFICATION_HEADER
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   CURSOR lqStatusType(
      anStatus                   IN       iapiType.StatusId_Type )
   IS
      SELECT status_type
        FROM STATUS
       WHERE STATUS = anStatus;

   lnExportErp                   NUMBER;
   lsStatusType                  iapiType.StatusType_Type;
   lnRetVal                      iapiType.ErrorNum_Type;
   lqErrors                      iapiType.Ref_Type;
   lsSource                      iapiType.Source_Type := 'TR_SPECIFICATION_HEADER_BU';
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_SPECIFICATION_HEADER_BU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   OPEN lqStatusType( :NEW.STATUS );

   FETCH lqStatusType
    INTO lsStatusType;

   CLOSE lqStatusType;

   IF :NEW.status <> :OLD.status
   THEN
--- Executes custom code
      lnRetVal := iapiSpecificationStatus.ExecuteStatusChangeCustomCode( :NEW.workflow_group_id,
                                                                         :NEW.status );

      IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.LogError( lsSource,
                               '',
                               iapiGeneral.GetLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;
   END IF;

   IF (     :NEW.planned_effective_date <> :OLD.planned_effective_date
        AND UPPER( NVL( lsStatusType,
                        '@@' ) ) <> 'DEVELOPMENT' )
   THEN
      lnRetVal := iapiEmail.RegisterEmail( :NEW.part_no,
                                           :NEW.revision,
                                           :NEW.STATUS,
                                           :OLD.planned_effective_date,
                                           'D',
                                           '',
                                           '',
                                           lqErrors );

      IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.LogError( lsSource,
                               '',
                               iapiGeneral.GetLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;

      SELECT COUNT( export_erp )
        INTO lnExportErp
        FROM WORKFLOW_GROUP wfg,
             WORK_FLOW wf
       WHERE wfg.workflow_group_id = :NEW.workflow_group_id
         AND wfg.work_flow_id = wf.work_flow_id
         AND wf.next_status = :NEW.STATUS
         AND wf.export_erp = 1;

      IF lnExportErp > 0
      THEN
         UPDATE PART
            SET CHANGED_DATE = SYSDATE
          WHERE part_no = :NEW.part_no;
      END IF;
   END IF;

   IF    :OLD.planned_effective_date <> :NEW.planned_effective_date
      OR :OLD.phase_in_tolerance <> :NEW.phase_in_tolerance
   THEN
      INSERT INTO JRNL_SPECIFICATION_HEADER
                  ( part_no,
                    revision,
                    user_id,
                    TIMESTAMP,
                    old_planned_effective_date,
                    old_phase_in_tolerance,
                    new_planned_effective_date,
                    new_phase_in_tolerance,
                    forename,
                    last_name )
           VALUES ( :OLD.part_no,
                    :OLD.revision,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    SYSDATE,
                    :OLD.planned_effective_date,
                    :OLD.phase_in_tolerance,
                    :NEW.planned_effective_date,
                    :NEW.phase_in_tolerance,
                    iapiGeneral.SESSION.ApplicationUser.ForeName,
                    iapiGeneral.SESSION.ApplicationUser.LastName );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_SPECIFICATION_HEADER_BU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPECIFICATION_HEADER_IES
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPECIFICATION_HEADER_IES" 
   BEFORE UPDATE
   ON SPECIFICATION_HEADER
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnExport   NUMBER;
   lnExportType NUMBER;
   rowcount NUMBER;
  es_cur SYS_REFCURSOR;
BEGIN

    SELECT COUNT(*) INTO rowcount FROM ITESTF;
      IF rowcount > 0
      THEN
         IF :NEW.status <> :OLD.status
         THEN
         FOR es_cur IN (SELECT tf.EXPORTTYPE as lnExportType
            FROM (WORK_FLOW sc
            JOIN WORKFLOW_GROUP wfg
            ON sc.WORK_FLOW_ID = wfg.WORK_FLOW_ID)
            INNER JOIN ITESTF tf
            ON (tf.FRAMENO = :NEW.FRAME_ID AND tf.OWNERID = :NEW.FRAME_OWNER)
           WHERE     sc.STATUS = :OLD.STATUS
                 AND sc.NEXT_STATUS = :NEW.status
                 --IS204 - rename EXPORT_TO_TC to EXPORT_TO_GIL
                 AND SC.EXPORT_TO_GIL = 1
                 AND wfg.WORKFLOW_GROUP_ID=:OLD.WORKFLOW_GROUP_ID
            GROUP BY tf.EXPORTTYPE)
        loop

        INSERT INTO ITESRQ (REQUESTID,
                                           PARTNO,
                                           REVISION,
                                           STATUS_FROM,
                                           STATUS_TO,
                                           DATEINSERTED,
                                           EXPORTTYPE,
                                           LANGID)
                 VALUES (itesrq_seq.NEXTVAL,
                         :NEW.PART_NO,
                         :NEW.REVISION,
                         :OLD.STATUS,
                         :NEW.STATUS,
                         SYSDATE,
                         es_cur.lnExportType,
                         1);
         end loop;
         END IF;
      ELSE
         --IS442 Start
         --iapiGeneral.LogError('TR_SPECIFICATION_HEADER_IES','','There is no EXPORTTYPE defined.'); --orig
         iapiGeneral.LogInfo( 'TR_SPECIFICATION_HEADER_IES', '', 'There is no EXPORTTYPE defined.', iapiConstant.INFOLEVEL_3 );
         --IS442 End
       END IF;
    END;
/
ALTER TRIGGER "INTERSPC"."TR_SPECIFICATION_HEADER_IES" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPECIFICATION_ING_AI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPECIFICATION_ING_AI" 
   AFTER INSERT
   ON SPECIFICATION_ING
   REFERENCING NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_SPECIFICATION_ING_AI';
   lnRetVal                      iapiType.ErrorNum_Type;

   CURSOR c_ingAllergens( lcIngredient IN  ITINGALLERGEN.ingredient%TYPE)
   IS
    SELECT allergen
    FROM itIngAllergen
    WHERE ingredient = lcIngredient
    AND status = 0;


   CURSOR c_props (lcAllergen IN ITINGALLERGEN.allergen%TYPE)
   IS
    SELECT property
    FROM itpropAllergen
    WHERE allergen = lcAllergen
    AND status = 0;

   --lcClaimType: 2 pos, 3 neg
   CURSOR c_claimProps ( lcPartNo   IN  ITSPECINGALLERGEN.part_no%TYPE,
                         lcRevision IN  ITSPECINGALLERGEN.revision%TYPE,
                         lcProperty IN  ITPROPALLERGEN.property%TYPE,
                         lcClaimType IN property_group.pg_type%TYPE)
   IS
    SELECT sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, sp.attribute
    FROM specification_prop sp, property_group pg
    WHERE sp.property_group = pg.property_group
    AND part_no = lcPartNo
    AND revision = lcRevision
    AND pg_type = lcClaimType
    AND property = lcProperty;

BEGIN
   IF    (iapiGeneral.SESSION.SETTINGS.International = TRUE)
     AND (:NEW.intl = '0')
   THEN
        RETURN;
   END IF;

   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

      FOR lrAllergen IN c_ingAllergens( :NEW.ingredient )
      LOOP
          FOR lrProps IN c_props( lrAllergen.allergen )
          LOOP
              --negative claims - check in bool1 field
              FOR lrClaimProps IN c_claimProps(:NEW.part_no, :NEW.revision, lrProps.property, 3)
              LOOP
                UPDATE specification_prop
                SET boolean_1 = 'Y' --for NEG claims
                WHERE part_no = lrClaimProps.part_no
                AND revision = lrClaimProps.revision
                AND section_id = lrClaimProps.section_id
                AND sub_section_id = lrClaimProps.sub_section_id
                AND property_group = lrClaimProps.property_group
                AND property = lrClaimProps.property
                AND attribute = lrClaimProps.attribute;
              END LOOP;

              --positive claims - uncheck bool1 field
              FOR lrClaimProps IN c_claimProps(:NEW.part_no, :NEW.revision, lrProps.property, 2)
              LOOP
                UPDATE specification_prop
                SET boolean_1 = 'N' --for POS claims
                WHERE part_no = lrClaimProps.part_no
                AND revision = lrClaimProps.revision
                AND section_id = lrClaimProps.section_id
                AND sub_section_id = lrClaimProps.sub_section_id
                AND property_group = lrClaimProps.property_group
                AND property = lrClaimProps.property
                and attribute = lrClaimProps.attribute;
              END LOOP;

          END LOOP;
       END LOOP;

EXCEPTION
WHEN OTHERS
THEN
    iapiGeneral.LogError( lsSource,
                          '',
                          'Cannot check/uncheck Claim property check box due to an error.' );
    iapiGeneral.LogError( lsSource,
                          '',
                          SQLERRM );
END;
/
ALTER TRIGGER "INTERSPC"."TR_SPECIFICATION_ING_AI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPP_OD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPP_OD" 
AFTER DELETE ON specification_prop
FOR EACH ROW

 DECLARE
BEGIN
DELETE FROM specification_prop_lang
WHERE part_no = :old.part_no
AND revision = :old.revision
AND section_id = :old.section_id
AND sub_section_id = :old.sub_section_id
AND property_group = :old.property_group
AND property = :old.property
AND attribute = :old.attribute ;
DELETE FROM specification_tm
WHERE part_no = :old.part_no
AND revision = :old.revision
AND section_id = :old.section_id
AND sub_section_id = :old.sub_section_id
AND property_group = :old.property_group
AND property = :old.property
AND attribute = :old.attribute ;
EXCEPTION
WHEN OTHERS THEN
raise_application_error(-20001, SQLERRM) ;
END TR_SPP_OD;
/
ALTER TRIGGER "INTERSPC"."TR_SPP_OD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPPHS_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPPHS_AD" 
   AFTER DELETE
   ON specification_prop
   FOR EACH ROW
DECLARE
   lsStatus                      iapiType.StatusType_Type;
   lsSource                      iapiType.Source_Type := 'Tr_Spphs_Ad';
   lnRetVal                      iapiType.ErrorNum_Type;
/******************************************************************************
NAME:       TR_SPPHS_AU
PURPOSE:    To perform work as each row is inserted or updated.
******************************************************************************/
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   SELECT st.status_type
     INTO lsStatus
     FROM specification_header sh,
          status st
    WHERE part_no = :OLD.part_no
      AND revision = :OLD.revision
      AND sh.status = st.status;

   IF lsStatus = iapiConstant.STATUSTYPE_DEVELOPMENT
   THEN
      lnRetVal := iapiSpecificationSection.CreateSectionHistory( :OLD.part_no,
                                                                 :OLD.revision,
                                                                 :OLD.section_id,
                                                                 :OLD.sub_section_id );

      IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.LogError( lsSource,
                               '',
                               iapiGeneral.GetLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            SQLERRM );
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
END;
/
ALTER TRIGGER "INTERSPC"."TR_SPPHS_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPPHS_AI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPPHS_AI" 
   AFTER INSERT
   ON specification_prop
   FOR EACH ROW
DECLARE
   lsStatus                      iapiType.StatusType_Type;
   lsSource                      iapiType.Source_Type := 'Tr_Spphs_Ai';
   lnRetVal                      iapiType.ErrorNum_Type;
/******************************************************************************
   NAME:       TR_SPPHS_AI
   PURPOSE:    To perform work as each row is inserted or updated.
******************************************************************************/
BEGIN
   SELECT st.status_type
     INTO lsStatus
     FROM specification_header sh,
          status st
    WHERE part_no = :NEW.part_no
      AND revision = :NEW.revision
      AND sh.status = st.status;

   IF lsStatus = iapiConstant.STATUSTYPE_DEVELOPMENT
   THEN
      lnRetVal := iapiSpecificationSection.CreateSectionHistory( :NEW.part_no,
                                                                 :NEW.revision,
                                                                 :NEW.section_id,
                                                                 :NEW.sub_section_id );

      IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.LogError( lsSource,
                               '',
                               iapiGeneral.GetLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            SQLERRM );
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
END;
/
ALTER TRIGGER "INTERSPC"."TR_SPPHS_AI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPPHS_AU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPPHS_AU" 
   AFTER UPDATE
   ON specification_prop
   FOR EACH ROW
DECLARE
   lsStatus                      iapiType.StatusType_Type;
   lsSource                      iapiType.Source_Type := 'Tr_Spphs_Au';
   lnRetVal                      iapiType.ErrorNum_Type;
/******************************************************************************
NAME:       TR_SPPHS_AU
PURPOSE:    To perform work as each row is inserted or updated.
******************************************************************************/
BEGIN
   SELECT st.status_type
     INTO lsStatus
     FROM specification_header sh,
          status st
    WHERE part_no = :OLD.part_no
      AND revision = :OLD.revision
      AND sh.status = st.status;


   --INTERSPC 1307 START
            -- Add data to specdata server.
     INSERT INTO SPECDATA_SERVER
                 ( part_no,
                   revision,
                   section_id,
                   sub_section_id )
     VALUES ( :NEW.part_no,
                    :NEW.Revision,
                    :NEW.section_id,
                    :NEW.sub_section_id );
   --INTERSPC 1307 END


  --IS1178 Start
   IF (
          (:OLD.part_no <> :NEW.part_no) OR
          (:OLD.revision <> :NEW.revision) OR
          (:OLD.section_id <> :NEW.section_id) OR
          (:OLD.sub_section_id <> :NEW.sub_section_id)
      )
   THEN
   --IS1178 End
   IF lsStatus = iapiConstant.STATUSTYPE_DEVELOPMENT
   THEN
      --AP01058362 --AP01033131 Start
      IF (iapiGeneral.SESSION.DATABASE.CreateSectionHistory = TRUE)
      THEN
      --AP01058362 --AP01033131 End
      lnRetVal := iapiSpecificationSection.CreateSectionHistory( :OLD.part_no,
                                                                 :OLD.revision,
                                                                 :OLD.section_id,
                                                                 :OLD.sub_section_id );
      --AP01058362 --AP01033131 Start
      END IF;
      --AP01058362 --AP01033131 End

      IF ( lnRetVal <> iapiConstantDbError.DBERR_SUCCESS )
      THEN
         iapiGeneral.LogError( lsSource,
                               '',
                               iapiGeneral.GetLastErrorText( ) );
         RAISE_APPLICATION_ERROR( -20000,
                                  iapiGeneral.GetLastErrorText( ) );
      END IF;
   END IF;
   --IS1178 Start
   END IF;
   --IS1178 End
EXCEPTION
   WHEN OTHERS
   THEN
      iapiGeneral.LogError( lsSource,
                            '',
                            SQLERRM );
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
END;
/
ALTER TRIGGER "INTERSPC"."TR_SPPHS_AU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SPPHS_AUSH
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SPPHS_AUSH" AFTER UPDATE ON specification_header FOR EACH ROW

 DECLARE
v_status status.status_type%TYPE ;
/******************************************************************************
   NAME:       TR_SPPHS_AU
   PURPOSE:    To perform work as each row is inserted or updated.
******************************************************************************/
BEGIN
   SELECT st.status_type
   INTO v_status
   FROM status st
   WHERE st.status = :old.status ;
   IF v_status <> 'DEVELOPMENT' THEN
      DELETE FROM itspphs
       WHERE part_no = :old.part_no
         AND revision = :old.revision ;
   END IF ;
   SELECT st.status_type
   INTO v_status
   FROM status st
   WHERE st.status = :new.status ;
   IF v_status = 'HISTORIC' THEN
      DELETE FROM itshvald
      WHERE part_no = :new.part_no
        AND revision = :new.revision ;
   END IF;
EXCEPTION
  WHEN OTHERS THEN
    Null;
END TR_SPP_AUDIT_AU;
/
ALTER TRIGGER "INTERSPC"."TR_SPPHS_AUSH" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_STAGE_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_STAGE_OI" 
   BEFORE INSERT
   ON STAGE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_STAGE_OI';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE STAGE_H
         SET max_rev = 0
       WHERE STAGE = :NEW.STAGE;

      INSERT INTO STAGE_H
                  ( STAGE,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.STAGE,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_STAGE_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_STAGE_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_STAGE_OU" 
   AFTER UPDATE OF description, status
   ON STAGE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'TR_STAGE_OU';
   lnRetVal                      iapiType.ErrorNum_Type;
   l_next_val                    NUMBER;
   lnRevision                    iapiType.Revision_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.description <> :NEW.description
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO lnRevision
        FROM STAGE_H
       WHERE stage = :NEW.stage
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE STAGE_H
         SET max_rev = 0
       WHERE stage = :NEW.stage
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM stage_H
       WHERE stage = :NEW.stage;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO STAGE_H
                  ( stage,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.stage,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO STAGE_H
                  ( stage,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.stage,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                1
           FROM STAGE_H
          WHERE stage = :NEW.stage
            AND revision = lnRevision
            AND lang_id <> 1;
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO ITENSSLOG
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'st',
                    :NEW.stage,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_STAGE_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_STATUS_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_STATUS_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON status
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   status%ROWTYPE;
   lrNewRecord                   status%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_STATUS_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.status := :OLD.status;
   lrOldRecord.sort_desc := :OLD.sort_desc;
   lrOldRecord.description := :OLD.description;
   lrOldRecord.status_type := :OLD.status_type;
   lrOldRecord.phase_in_status := :OLD.phase_in_status;
   lrOldRecord.email_title := :OLD.email_title;
   lrOldRecord.prompt_for_reason := :OLD.prompt_for_reason;
   lrOldRecord.reason_mandatory := :OLD.reason_mandatory;
   lrOldRecord.es := :OLD.es;
   lrNewRecord.status := :NEW.status;
   lrNewRecord.sort_desc := :NEW.sort_desc;
   lrNewRecord.description := :NEW.description;
   lrNewRecord.status_type := :NEW.status_type;
   lrNewRecord.phase_in_status := :NEW.phase_in_status;
   lrNewRecord.email_title := :NEW.email_title;
   lrNewRecord.prompt_for_reason := :NEW.prompt_for_reason;
   lrNewRecord.reason_mandatory := :NEW.reason_mandatory;
   lrNewRecord.es := :NEW.es;
   lnRetVal := iapiAuditTrail.AddStatusHistory( lsAction,
                                                lrOldRecord,
                                                lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_STATUS_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SUB_SECTION_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SUB_SECTION_OI" 
   BEFORE INSERT
   ON SUB_SECTION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText(iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_SUB_SECTION_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE sub_section_h
         SET max_rev = 0
       WHERE sub_section_id = :NEW.sub_section_id;

      INSERT INTO SUB_SECTION_H
                  ( sub_section_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.sub_section_id,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_SUB_SECTION_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_SUB_SECTION_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_SUB_SECTION_OU" 
   AFTER UPDATE OF description, status
   ON SUB_SECTION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Sub_Section_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
   l_next_val                    NUMBER;
   l_bubble                      VARCHAR2( 1000 );
   l_revision                    NUMBER;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.description <> :NEW.description
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM sub_section_h
       WHERE sub_section_id = :NEW.sub_section_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE sub_section_h
         SET max_rev = 0
       WHERE sub_section_id = :NEW.sub_section_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM SUB_SECTION_H
       WHERE sub_section_id = :NEW.sub_section_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO SUB_SECTION_H
                  ( sub_section_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.sub_section_id,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO SUB_SECTION_H
                  ( sub_section_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.sub_section_id,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                1
           FROM sub_section_h
          WHERE sub_section_id = :NEW.sub_section_id
            AND revision = l_revision
            AND lang_id <> 1;

      SELECT MAX( revision )
        INTO l_revision
        FROM sub_section_b
       WHERE revision < l_next_val
         AND sub_section_id = :NEW.sub_section_id
         AND lang_id = 1;

      IF l_revision IS NOT NULL
      THEN
         SELECT bubble
           INTO l_bubble
           FROM sub_section_b
          WHERE revision = l_revision
            AND lang_id = 1
            AND sub_section_id = :NEW.sub_section_id;

         INSERT INTO sub_section_b
                     ( sub_section_id,
                       revision,
                       lang_id,
                       bubble,
                       last_modified_on,
                       last_modified_by )
              VALUES ( :NEW.sub_section_id,
                       l_next_val,
                       1,
                       l_bubble,
                       SYSDATE,
                       iapiGeneral.SESSION.ApplicationUser.UserId );
      END IF;
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'sb',
                    :NEW.sub_section_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_SUB_SECTION_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_TEST_METHOD_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_TEST_METHOD_OI" 
   BEFORE INSERT
   ON TEST_METHOD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Test_Method_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE test_method_h
         SET max_rev = 0
       WHERE test_method = :NEW.test_method;

      INSERT INTO TEST_METHOD_H
                  ( test_method,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev,
                    long_descr )
           VALUES ( :NEW.test_method,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1,
                    :NEW.long_descr );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_TEST_METHOD_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_TEST_METHOD_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_TEST_METHOD_OU" 
   AFTER UPDATE OF description, status, long_descr
   ON TEST_METHOD
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Test_Method_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
   l_revision                    NUMBER;
   l_next_val                    NUMBER;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM test_method_h
       WHERE test_method = :NEW.test_method
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE test_method_h
         SET max_rev = 0
       WHERE test_method = :NEW.test_method
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM TEST_METHOD_H
       WHERE test_method = :NEW.test_method;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO TEST_METHOD_H
                  ( test_method,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev,
                    long_descr )
           VALUES ( :NEW.test_method,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1,
                    :NEW.long_descr );

      INSERT INTO TEST_METHOD_H
                  ( test_method,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev,
                    long_descr )
         SELECT :NEW.test_method,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                1,
                long_descr
           FROM test_method_h
          WHERE test_method = :NEW.test_method
            AND revision = l_revision
            AND lang_id <> 1;
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'tm',
                    :NEW.test_method,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );

      NULL;
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_TEST_METHOD_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_TEXT_TYPE_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_TEXT_TYPE_OI" 
   BEFORE INSERT
   ON TEXT_TYPE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Text_Type_Oi';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE text_type_h
         SET max_rev = 0
       WHERE text_type = :NEW.text_type;

      INSERT INTO TEXT_TYPE_H
                  ( text_type,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.text_type,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_TEXT_TYPE_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_TEXT_TYPE_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_TEXT_TYPE_OU" 
   AFTER UPDATE OF description, status
   ON TEXT_TYPE
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Tr_Text_Type_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
   l_next_val                    NUMBER;
   l_bubble                      VARCHAR2( 1000 );
   l_revision                    NUMBER;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.description <> :NEW.description
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO l_revision
        FROM text_type_h
       WHERE text_type = :NEW.text_type
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE text_type_h
         SET max_rev = 0
       WHERE text_type = :NEW.text_type
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM text_type_H
       WHERE text_type = :NEW.text_type;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO TEXT_TYPE_H
                  ( text_type,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.text_type,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO TEXT_TYPE_H
                  ( text_type,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.text_type,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                1
           FROM text_type_h
          WHERE text_type = :NEW.text_type
            AND revision = l_revision
            AND lang_id <> 1;

      SELECT MAX( revision )
        INTO l_revision
        FROM text_type_b
       WHERE revision < l_next_val
         AND text_type = :NEW.text_type
         AND lang_id = 1;

      IF l_revision IS NOT NULL
      THEN
         SELECT bubble
           INTO l_bubble
           FROM text_type_b
          WHERE revision = l_revision
            AND lang_id = 1
            AND text_type = :NEW.text_type;

         INSERT INTO text_type_b
                     ( text_type,
                       revision,
                       lang_id,
                       bubble,
                       last_modified_on,
                       last_modified_by )
              VALUES ( :NEW.text_type,
                       l_next_val,
                       1,
                       l_bubble,
                       SYSDATE,
                       iapiGeneral.SESSION.ApplicationUser.UserId );
      END IF;
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'tt',
                    :NEW.text_type,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_TEXT_TYPE_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_UOM_GROUP_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_UOM_GROUP_OI" 
   BEFORE INSERT
   ON UOM_GROUP
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_UOM_GROUP_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE UOM_GROUP_h
         SET max_rev = 0
       WHERE uom_group = :NEW.uom_group;

      INSERT INTO UOM_GROUP_H
                  ( uom_group,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.uom_group,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_UOM_GROUP_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_UOM_GROUP_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_UOM_GROUP_OU" 
   AFTER UPDATE OF description, status
   ON UOM_GROUP
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_bubble                      VARCHAR2( 1000 );
   lnRevision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_UOM_GROUP_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.description <> :NEW.description
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO lnRevision
        FROM UOM_GROUP_H
       WHERE uom_group = :NEW.uom_group
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE UOM_GROUP_H
         SET max_rev = 0
       WHERE uom_group = :NEW.uom_group
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM UOM_GROUP_H
       WHERE uom_group = :NEW.uom_group;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO UOM_GROUP_H
                  ( uom_group,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.uom_group,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO UOM_GROUP_H
                  ( uom_group,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.uom_group,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                1
           FROM UOM_GROUP_H
          WHERE uom_group = :NEW.uom_group
            AND revision = lnRevision
            AND lang_id <> 1;

      SELECT MAX( revision )
        INTO lnRevision
        FROM UOM_GROUP_B
       WHERE revision < l_next_val
         AND uom_group = :NEW.uom_group
         AND lang_id = 1;

      IF lnRevision IS NOT NULL
      THEN
         SELECT bubble
           INTO l_bubble
           FROM UOM_GROUP_B
          WHERE revision = lnRevision
            AND lang_id = 1
            AND uom_group = :NEW.uom_group;

         INSERT INTO UOM_GROUP_B
                     ( uom_group,
                       revision,
                       lang_id,
                       bubble,
                       last_modified_on,
                       last_modified_by )
              VALUES ( :NEW.uom_group,
                       l_next_val,
                       1,
                       l_bubble,
                       SYSDATE,
                       iapiGeneral.SESSION.ApplicationUser.UserId );
      END IF;
   END IF;

   --IF UOM_GROUP TABLE PLAY IN 3-TIER THEN USE THE ALLOW

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'ug',
                    :NEW.uom_group,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;

END;
/
ALTER TRIGGER "INTERSPC"."TR_UOM_GROUP_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_UOM_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_UOM_OI" 
   BEFORE INSERT
   ON UOM
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_UOM_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      UPDATE uom_h
         SET max_rev = 0
       WHERE uom_id = :NEW.uom_id;

      INSERT INTO UOM_H
                  ( uom_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.uom_id,
                    100,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );
   END IF;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX
  THEN
    NULL;
  WHEN OTHERS
  THEN
     iapiGeneral.LogError( 'TRigger',
                           'TR_UOM_OI',
                           SQLERRM );

END;
/
ALTER TRIGGER "INTERSPC"."TR_UOM_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_UOM_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_UOM_OU" 
   AFTER UPDATE OF description, status
   ON UOM
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_bubble                      VARCHAR2( 1000 );
   lnRevision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_UOM_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.description <> :NEW.description
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      SELECT revision
        INTO lnRevision
        FROM uom_h
       WHERE uom_id = :NEW.uom_id
         AND max_rev = 1
         AND lang_id = 1;

      UPDATE uom_h
         SET max_rev = 0
       WHERE uom_id = :NEW.uom_id
         AND max_rev = 1;

      SELECT (    (   TRUNC(   MAX( revision )
                             / 100 )
                    + 1 )
               * 100 )
        INTO l_next_val
        FROM UOM_H
       WHERE uom_id = :NEW.uom_id;

      IF l_next_val IS NULL
      THEN
         l_next_val := 1;
      END IF;

      INSERT INTO UOM_H
                  ( uom_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
           VALUES ( :NEW.uom_id,
                    l_next_val,
                    1,
                    :NEW.description,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    1 );

      INSERT INTO UOM_H
                  ( uom_id,
                    revision,
                    lang_id,
                    description,
                    last_modified_on,
                    last_modified_by,
                    max_rev )
         SELECT :NEW.uom_id,
                l_next_val,
                lang_id,
                description,
                last_modified_on,
                last_modified_by,
                1
           FROM uom_h
          WHERE uom_id = :NEW.uom_id
            AND revision = lnRevision
            AND lang_id <> 1;

      SELECT MAX( revision )
        INTO lnRevision
        FROM uom_b
       WHERE revision < l_next_val
         AND uom_id = :NEW.uom_id
         AND lang_id = 1;

      IF lnRevision IS NOT NULL
      THEN
         SELECT bubble
           INTO l_bubble
           FROM uom_b
          WHERE revision = lnRevision
            AND lang_id = 1
            AND uom_id = :NEW.uom_id;

         INSERT INTO uom_b
                     ( uom_id,
                       revision,
                       lang_id,
                       bubble,
                       last_modified_on,
                       last_modified_by )
              VALUES ( :NEW.uom_id,
                       l_next_val,
                       1,
                       l_bubble,
                       SYSDATE,
                       iapiGeneral.SESSION.ApplicationUser.UserId );
      END IF;
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND :OLD.status <> :NEW.status
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO itensslog
                  ( en_tp,
                    en_id,
                    status_change_date,
                    user_id,
                    status )
           VALUES ( 'um',
                    :NEW.uom_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    :NEW.status );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_UOM_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_UOM_UOM_GROUP_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_UOM_UOM_GROUP_OI" 
   BEFORE INSERT
   ON UOM_UOM_GROUP
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_UOM_UOM_GROUP_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN

      INSERT INTO UOM_UOM_GROUP_H(
				UOM_GROUP,
				UOM_ID,
				LAST_MODIFIED_ON,
				LAST_MODIFIED_BY,
				ACTION,
				INTL)
           VALUES ( :NEW.uom_group,
                    :NEW.uom_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl);

     --IF UOM_GROUP TABLE PLAY IN 3-TIER THEN USE THE ALLOW
     IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                    AND :NEW.intl = '0' )
              OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
        AND :OLD.status <> :NEW.status
        AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
     THEN
       INSERT INTO itensslog
                   ( en_tp,
                     en_id,
                     status_change_date,
                     user_id,
                     status )
            VALUES ( 'uu',
                     :NEW.uom_id,
                     SYSDATE,
                     iapiGeneral.SESSION.ApplicationUser.UserId,
                     :NEW.status );
      END IF;




   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_UOM_UOM_GROUP_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_UOM_UOM_GROUP_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_UOM_UOM_GROUP_OU" 
   BEFORE UPDATE ON UOM_UOM_GROUP
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   l_next_val                    NUMBER;
   l_bubble                      VARCHAR2( 1000 );
   lnRevision                    NUMBER;
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN

   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_UOM_UOM_GROUP_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO UOM_UOM_GROUP_H(
				UOM_GROUP,
				UOM_ID,
				LAST_MODIFIED_ON,
				LAST_MODIFIED_BY,
				ACTION,
				INTL)
           VALUES ( :NEW.uom_group,
                    :NEW.uom_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl);
   END IF;

END;
/
ALTER TRIGGER "INTERSPC"."TR_UOM_UOM_GROUP_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_UOMC_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_UOMC_OI" 
   BEFORE INSERT
   ON UOMC
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_UOMC_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO UOMC_H
                  ( uom_id,
                    uom_alt_id,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl,
                    conv_factor )
           VALUES ( :NEW.uom_id,
                    :NEW.uom_alt_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl,
                    :NEW.conv_factor );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_UOMC_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_UOMC_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_UOMC_OU" 
   BEFORE UPDATE
   ON UOMC
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_UOMC_OU',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO UOMC_H
                  ( uom_id,
                    uom_alt_id,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl,
                    conv_factor )
           VALUES ( :NEW.uom_id,
                    :NEW.uom_alt_id,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl,
                    :NEW.conv_factor );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_UOMC_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_USER_ACCESS_GROUP_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_USER_ACCESS_GROUP_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON user_access_group
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsaction      VARCHAR2 (20);
   lroldrecord   user_access_group%ROWTYPE;
   lrnewrecord   user_access_group%ROWTYPE;
   lssource      iapitype.source_type        := 'TR_USER_ACCESS_GROUP_HS';
   lnretval      iapitype.errornum_type;
   lnusergroupid NUMBER;
BEGIN
   -- Do not insert logging for Report Manager
   -- This is only a big fix, architecture of RM should be changed to do this the correct way
   BEGIN
      SELECT user_group_id
        INTO lnusergroupid
        FROM user_group
       WHERE short_desc = 'RM_GRP';

        IF lnusergroupid = :NEW.user_group_id THEN
            RETURN;
        END IF;
   EXCEPTION WHEN OTHERS THEN
    NULL;
   END;

   IF INSERTING
   THEN
      lsaction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsaction := 'UPDATING';
   ELSE
      lsaction := 'DELETING';
   END IF;

   lroldrecord.access_group := :OLD.access_group;
   lroldrecord.user_group_id := :OLD.user_group_id;
   lroldrecord.update_allowed := :OLD.update_allowed;
   lroldrecord.mrp_update := :OLD.mrp_update;
   lrnewrecord.access_group := :NEW.access_group;
   lrnewrecord.user_group_id := :NEW.user_group_id;
   lrnewrecord.update_allowed := :NEW.update_allowed;
   lrnewrecord.mrp_update := :NEW.mrp_update;
   lnretval :=
      iapiaudittrail.addaccessgrouplisthistory (lsaction,
                                                lroldrecord,
                                                lrnewrecord
                                               );

   IF (lnretval <> iapiconstantdberror.dberr_success)
   THEN
      iapigeneral.logerror (lssource, '', iapigeneral.getlasterrortext ());
      raise_application_error (-20000, iapigeneral.getlasterrortext ());
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_USER_ACCESS_GROUP_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_USER_GROUP_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_USER_GROUP_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON user_group
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   user_group%ROWTYPE;
   lrNewRecord                   user_group%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_USER_GROUP_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.user_group_id := :OLD.user_group_id;
   lrOldRecord.short_desc := :OLD.short_desc;
   lrOldRecord.description := :OLD.description;
   lrNewRecord.user_group_id := :NEW.user_group_id;
   lrNewRecord.short_desc := :NEW.short_desc;
   lrNewRecord.description := :NEW.description;
   lnRetVal := iapiAuditTrail.AddUserGroupHistory( lsAction,
                                                   lrOldRecord,
                                                   lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_USER_GROUP_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_USER_GROUP_LIST_BD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_USER_GROUP_LIST_BD" 
   BEFORE DELETE
   ON USER_GROUP_LIST    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   --This trigger is created for --AP01058356 --AP00999619
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'TR_USER_GROUP_LIST_BD',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

  --delete record from APPROVER_SELECTED
  DELETE FROM APPROVER_SELECTED
  WHERE user_id = :OLD.user_id
    AND user_group_id = :OLD.user_group_id;

END;
/
ALTER TRIGGER "INTERSPC"."TR_USER_GROUP_LIST_BD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_USER_GROUP_LIST_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_USER_GROUP_LIST_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON user_group_list
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   user_group_list%ROWTYPE;
   lrNewRecord                   user_group_list%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_USER_GROUP_LIST_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.user_group_id := :OLD.user_group_id;
   lrOldRecord.user_id := :OLD.user_id;
   lrNewRecord.user_group_id := :NEW.user_group_id;
   lrNewRecord.user_id := :NEW.user_id;
   lnRetVal := iapiAuditTrail.AddUserGroupListHistory( lsAction,
                                                       lrOldRecord,
                                                       lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_USER_GROUP_LIST_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_USER_WORKFLOW_GROUP_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_USER_WORKFLOW_GROUP_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON user_workflow_group
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   user_workflow_group%ROWTYPE;
   lrNewRecord                   user_workflow_group%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_USER_WORKFLOW_GROUP_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.workflow_group_id := :OLD.workflow_group_id;
   lrOldRecord.user_group_id := :OLD.user_group_id;
   lrNewRecord.workflow_group_id := :NEW.workflow_group_id;
   lrNewRecord.user_group_id := :NEW.user_group_id;
   lnRetVal := iapiAuditTrail.AddWorkflowGroupFilterHistory( lsAction,
                                                             lrOldRecord,
                                                             lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_USER_WORKFLOW_GROUP_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_WORK_FLOW_GROUP_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_WORK_FLOW_GROUP_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON work_flow_group
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   work_flow_group%ROWTYPE;
   lrNewRecord                   work_flow_group%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_WORK_FLOW_GROUP_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.work_flow_id := :OLD.work_flow_id;
   lrOldRecord.description := :OLD.description;
   lrOldRecord.initial_status := :OLD.initial_status;
   lrNewRecord.work_flow_id := :NEW.work_flow_id;
   lrNewRecord.description := :NEW.description;
   lrNewRecord.initial_status := :NEW.initial_status;
   lnRetVal := iapiAuditTrail.AddWorkflowTypeHistory( lsAction,
                                                      lrOldRecord,
                                                      lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_WORK_FLOW_GROUP_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_WORK_FLOW_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_WORK_FLOW_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON work_flow
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   work_flow%ROWTYPE;
   lrNewRecord                   work_flow%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_WORK_FLOW_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.work_flow_id := :OLD.work_flow_id;
   lrOldRecord.status := :OLD.status;
   lrOldRecord.next_status := :OLD.next_status;
   lrOldRecord.export_erp := :OLD.export_erp;
   lrNewRecord.work_flow_id := :NEW.work_flow_id;
   lrNewRecord.status := :NEW.status;
   lrNewRecord.next_status := :NEW.next_status;
   lrNewRecord.export_erp := :NEW.export_erp;
   lnRetVal := iapiAuditTrail.AddWorkflowTypeListHistory( lsAction,
                                                          lrOldRecord,
                                                          lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_WORK_FLOW_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_WORK_FLOW_LIST_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_WORK_FLOW_LIST_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON work_flow_list
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   work_flow_list%ROWTYPE;
   lrNewRecord                   work_flow_list%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_WORK_FLOW_LIST_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.workflow_group_id := :OLD.workflow_group_id;
   lrOldRecord.status := :OLD.status;
   lrOldRecord.user_group_id := :OLD.user_group_id;
   lrOldRecord.all_to_approve := :OLD.all_to_approve;
   lrOldRecord.send_mail := :OLD.send_mail;
   lrOldRecord.eff_date_mail := :OLD.eff_date_mail;
   lrNewRecord.workflow_group_id := :NEW.workflow_group_id;
   lrNewRecord.status := :NEW.status;
   lrNewRecord.user_group_id := :NEW.user_group_id;
   lrNewRecord.all_to_approve := :NEW.all_to_approve;
   lrNewRecord.send_mail := :NEW.send_mail;
   lrNewRecord.eff_date_mail := :NEW.eff_date_mail;
   lnRetVal := iapiAuditTrail.AddWorkflowGroupListHistory( lsAction,
                                                           lrOldRecord,
                                                           lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_WORK_FLOW_LIST_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_WORKFLOW_GROUP_HS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."TR_WORKFLOW_GROUP_HS" 
   AFTER INSERT OR UPDATE OR DELETE
   ON workflow_group
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsAction                      VARCHAR2( 20 );
   lrOldRecord                   workflow_group%ROWTYPE;
   lrNewRecord                   workflow_group%ROWTYPE;
   lsSource                      iapiType.Source_Type := 'TR_WORKFLOW_GROUP_HS';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF INSERTING
   THEN
      lsAction := 'INSERTING';
   ELSIF UPDATING
   THEN
      lsAction := 'UPDATING';
   ELSE
      lsAction := 'DELETING';
   END IF;

   lrOldRecord.workflow_group_id := :OLD.workflow_group_id;
   lrOldRecord.sort_desc := :OLD.sort_desc;
   lrOldRecord.description := :OLD.description;
   lrOldRecord.work_flow_id := :OLD.work_flow_id;
   lrNewRecord.workflow_group_id := :NEW.workflow_group_id;
   lrNewRecord.sort_desc := :NEW.sort_desc;
   lrNewRecord.description := :NEW.description;
   lrNewRecord.work_flow_id := :NEW.work_flow_id;
   lnRetVal := iapiAuditTrail.AddWorkflowGroupHistory( lsAction,
                                                       lrOldRecord,
                                                       lrNewRecord );

   IF ( lnRetval <> iapiConstantDbError.DBERR_SUCCESS )
   THEN
      iapiGeneral.logError( lsSource,
                            '',
                            iapiGeneral.getLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."TR_WORKFLOW_GROUP_HS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger UOM_ASSOCIATION_AD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."UOM_ASSOCIATION_AD" 
   BEFORE DELETE
   ON UOM_ASSOCIATION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Uom_Association_Ad';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :OLD.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO uom_association_h
                  ( association,
                    uom,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl,
                    lower_reject,
                    upper_reject )
           VALUES ( :OLD.association,
                    :OLD.uom,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'D',
                    :OLD.intl,
                    :OLD.lower_reject,
                    :OLD.upper_reject );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."UOM_ASSOCIATION_AD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger UOM_ASSOCIATION_OI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."UOM_ASSOCIATION_OI" 
   BEFORE INSERT
   ON UOM_ASSOCIATION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText(iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( 'UOM_ASSOCIATION_OI',
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO uom_association_h
                  ( association,
                    uom,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl,
                    lower_reject,
                    upper_reject )
           VALUES ( :NEW.association,
                    :NEW.uom,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'I',
                    :NEW.intl,
                    :NEW.lower_reject,
                    :NEW.upper_reject );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."UOM_ASSOCIATION_OI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger UOM_ASSOCIATION_OU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."UOM_ASSOCIATION_OU" 
   BEFORE UPDATE
   ON UOM_ASSOCIATION
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lsSource                      iapiType.Source_Type := 'Uom_Association_Ou';
   lnRetVal                      iapiType.ErrorNum_Type;
BEGIN
   IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
   THEN
      lnRetVal := iapiGeneral.SetErrorText( iapiConstantDbError.DBERR_NOINITSESSION );
      iapiGeneral.LogError( lsSource,
                            '',
                            iapiGeneral.GetLastErrorText( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               iapiGeneral.GetLastErrorText( ) );
   END IF;

   IF     (     (     iapiGeneral.SESSION.DATABASE.DatabaseType IN( 'L', 'R' )
                  AND :NEW.intl = '0' )
            OR ( iapiGeneral.SESSION.DATABASE.DatabaseType = 'G' ) )
      AND iapiGeneral.SESSION.DATABASE.Configuration.Glossary
   THEN
      INSERT INTO uom_association_h
                  ( association,
                    uom,
                    last_modified_on,
                    last_modified_by,
                    action,
                    intl,
                    lower_reject,
                    upper_reject )
           VALUES ( :NEW.association,
                    :NEW.uom,
                    SYSDATE,
                    iapiGeneral.SESSION.ApplicationUser.UserId,
                    'U',
                    :NEW.intl,
                    :NEW.lower_reject,
                    :NEW.upper_reject );
   END IF;
END;
/
ALTER TRIGGER "INTERSPC"."UOM_ASSOCIATION_OU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger VR_PART_AU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INTERSPC"."VR_PART_AU" 
AFTER UPDATE OF description ON part
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
   -- descriptions and language codes should be managed by masterdata interface
   IF :new.part_source = 'CMD' THEN
      UPDATE part_l
      SET description = :new.description
      WHERE part_no = :new.part_no
      AND lang_id = 1;
   END IF;
END VR_part_au; 

/
ALTER TRIGGER "INTERSPC"."VR_PART_AU" ENABLE;

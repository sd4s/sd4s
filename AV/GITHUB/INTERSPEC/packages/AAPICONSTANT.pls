create or replace PACKAGE aapiConstant
IS
   --
   --General
   --
   BOOLEAN_TRUE                   CONSTANT iapiType.Boolean_Type                  := 1;
   BOOLEAN_FALSE                  CONSTANT iapiType.Boolean_Type                  := 0;
   YES                            CONSTANT CHAR                                   := 'Y';
   NO                             CONSTANT CHAR                                   := 'N';
   PLACEHOLDER_ALL                CONSTANT VARCHAR2(20)                           := '<ALL>';
   --
   -- LOGGING ACTIONS
   --
   ACTION_INSERT                  CONSTANT CHAR                                   := 'I';
   ACTION_DELETE                  CONSTANT CHAR                                   := 'D';
   ACTION_UPDATE                  CONSTANT CHAR                                   := 'U';
   --
   --Additional section items (ANY hooks are returned as a negative number by the API calls)
   --
   SECTIONTYPE_ANYOBJECT          CONSTANT iapiType.SpecificationSectionType_Type
                                                                := -iapiConstant.SECTIONTYPE_OBJECT;
   SECTIONTYPE_ANYREFERENCETEXT   CONSTANT iapiType.SpecificationSectionType_Type
                                                         := -iapiConstant.SECTIONTYPE_REFERENCETEXT;
   --
   -- Property group field types
   --
   FIELDTYPE_NUMERIC1             CONSTANT iapiType.Id_Type                       := 1;
   FIELDTYPE_NUMERIC2             CONSTANT iapiType.Id_Type                       := 2;
   FIELDTYPE_NUMERIC3             CONSTANT iapiType.Id_Type                       := 3;
   FIELDTYPE_NUMERIC4             CONSTANT iapiType.Id_Type                       := 4;
   FIELDTYPE_NUMERIC5             CONSTANT iapiType.Id_Type                       := 5;
   FIELDTYPE_NUMERIC6             CONSTANT iapiType.Id_Type                       := 6;
   FIELDTYPE_NUMERIC7             CONSTANT iapiType.Id_Type                       := 7;
   FIELDTYPE_NUMERIC8             CONSTANT iapiType.Id_Type                       := 8;
   FIELDTYPE_NUMERIC9             CONSTANT iapiType.Id_Type                       := 9;
   FIELDTYPE_NUMERIC10            CONSTANT iapiType.Id_Type                       := 10;
   FIELDTYPE_CHARACTER1           CONSTANT iapiType.Id_Type                       := 11;
   FIELDTYPE_CHARACTER2           CONSTANT iapiType.Id_Type                       := 12;
   FIELDTYPE_CHARACTER3           CONSTANT iapiType.Id_Type                       := 13;
   FIELDTYPE_CHARACTER4           CONSTANT iapiType.Id_Type                       := 14;
   FIELDTYPE_CHARACTER5           CONSTANT iapiType.Id_Type                       := 15;
   FIELDTYPE_CHARACTER6           CONSTANT iapiType.Id_Type                       := 16;
   FIELDTYPE_BOOLEAN1             CONSTANT iapiType.Id_Type                       := 17;
   FIELDTYPE_BOOLEAN2             CONSTANT iapiType.Id_Type                       := 18;
   FIELDTYPE_BOOLEAN3             CONSTANT iapiType.Id_Type                       := 19;
   FIELDTYPE_BOOLEAN4             CONSTANT iapiType.Id_Type                       := 20;
   FIELDTYPE_DATE1                CONSTANT iapiType.Id_Type                       := 21;
   FIELDTYPE_DATE2                CONSTANT iapiType.Id_Type                       := 22;
   FIELDTYPE_UOM                  CONSTANT iapiType.Id_Type                       := 23;
   FIELDTYPE_ATTRIBUTE            CONSTANT iapiType.Id_Type                       := 24;
   FIELDTYPE_TESTMETHOD           CONSTANT iapiType.Id_Type                       := 25;
   FIELDTYPE_ASSOCIATION1         CONSTANT iapiType.Id_Type                       := 26;
   FIELDTYPE_PROPERTY             CONSTANT iapiType.Id_Type                       := 27;
   FIELDTYPE_ASSOCIATION2         CONSTANT iapiType.Id_Type                       := 30;
   FIELDTYPE_ASSOCIATION3         CONSTANT iapiType.Id_Type                       := 31;
   FIELDTYPE_TESTDETAIL1          CONSTANT iapiType.Id_Type                       := 32;
   FIELDTYPE_TESTDETAIL2          CONSTANT iapiType.Id_Type                       := 33;
   FIELDTYPE_TESTDETAIL3          CONSTANT iapiType.Id_Type                       := 34;
   FIELDTYPE_TESTDETAIL4          CONSTANT iapiType.Id_Type                       := 35;
   FIELDTYPE_NOTE                 CONSTANT iapiType.Id_Type                       := 40;
   FIELDTYPE_TMDETAILS            CONSTANT iapiType.Id_Type                       := 41;
   --
   -- Security by section
   --
   ACCESSLEVEL_NOVIEW_SECTION     CONSTANT iapiType.Id_Type                       := 0;
   ACCESSLEVEL_NOEDIT             CONSTANT iapiType.Id_Type                       := 1;
   ACCESSLEVEL_NOVIEW_ITEM        CONSTANT iapiType.Id_Type                       := 2;
END aapiConstant;
 
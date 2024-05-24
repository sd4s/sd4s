create or replace PACKAGE iapiConstantDbError IS
  ---------------------------------------------------------------------------
  -- $Workfile: iapiConstantDbError.h $
  ---------------------------------------------------------------------------
  --   $Author: evoVaLa3 $
  -- $Revision: 6.7.0.10 (06.07.00.10-00.00) $
  --  $Modtime: 2017-March-03 12:00 $
  --   Project: Interspec DB API
  ---------------------------------------------------------------------------
  --  Abstract:
  --           This class contains a list of
  --           database error numbers
  --
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  -- $NoKeywords: $
  ---------------------------------------------------------------------------

  ---------------------------------------------------------------------------
  -- Constant definitions
  ---------------------------------------------------------------------------
  DBERR_ACCESSGROUPISMANDATORY   CONSTANT NUMBER := 428; --The Access group  is mandatory.
  DBERR_ACCESSGROUPNOTEXIST      CONSTANT NUMBER := 354; --Access group %1 does not exist.
  DBERR_ACTIONNOTALLOWED         CONSTANT NUMBER := 187; --Action %1, not allowed for item %2 type %3 in specfication %4 [%5] section %6-%7 due to frame or mask.
  DBERR_ALLMANDATORYFIELDREQ     CONSTANT NUMBER := 169; --Not all Mandatory fields are having values : PART NO (%1), REVISION (%2),STATUS (%3),FRAME (%4),WORKFLOW (%5), ACCESS (%6), DATE (%7), Original PART (%8), Original REVISION (%9)
  DBERR_ALTPRIORITYLESSTHANONE   CONSTANT NUMBER := 301; --The alternative priority cannot be less than 1.
  DBERR_APPLICATIONERROR         CONSTANT NUMBER := 20; --Application error (%1): %2
  DBERR_ATTACHEDOBJISNOTCURRENT  CONSTANT NUMBER := 327; --One of the attached objects is not current.
  DBERR_ATTACHEDPARTNODATA       CONSTANT NUMBER := 360; --Attached Part <%1> has no Specification Data. Specification %2 [%3].
  DBERR_ATTACHEDPARTTOOMANY      CONSTANT NUMBER := 361; --Attached Part <%1> is more than once in the list. For Specification %2 [%3].
  DBERR_ATTACHEDSPECISNOTCURRENT CONSTANT NUMBER := 326; --One of the attached specifications has no current or approved revision.
  DBERR_ATTACHEDSPECNOTFOUND     CONSTANT NUMBER := 339; --No attached specification found.
  DBERR_ATTREFTEXTISNOTCURRENT   CONSTANT NUMBER := 328; --One of the attached reference texts is not current.
  DBERR_ATTRIBUTENOTFOUND        CONSTANT NUMBER := 138; --Attribute (%1,%2) not found.
  DBERR_BASEIDALREADYEXIST       CONSTANT NUMBER := 140; --Base name %1 already exists for specification %2 [%3]
  DBERR_BASENAMENOTFOUND         CONSTANT NUMBER := 341; --Base Name not found.
  DBERR_BOMDEVPLANTNOALT         CONSTANT NUMBER := 85; --The DEV plant cannot have mulliple alternatives.
  DBERR_BOMDFEXIST               CONSTANT NUMBER := 209; --BOM Display Format already exists with Layout ID %1 and Revision %2.
  DBERR_BOMDFNOTFOUND            CONSTANT NUMBER := 128; --BOM Display Format not found for Layout ID %1 and Revision %2.
  DBERR_BOMHEADERALREADYEXIST    CONSTANT NUMBER := 365; --BoM Header already exists.
  DBERR_BOMHEADERNOTEXIST        CONSTANT NUMBER := 367; --BoM Header %1 - %2 - %3 - %4 - does not exist.
  DBERR_BOMHEADERNOTFOUND        CONSTANT NUMBER := 334; --BoM Header not found.
  DBERR_BOMITEMCOSTBULKMUTEXCL   CONSTANT NUMBER := 81; --The fields Relevency To Costing and Bulk Material are mutual exclusive.
  DBERR_BOMITEMDONTMATCHHEADER   CONSTANT NUMBER := 315; --BOM ITEM records do not match BOM HEADER for spec %1 %2.
  DBERR_BOMITEMHISTORICOBSOLETE  CONSTANT NUMBER := 7; --The Bom item %1 [%2] has status type HISTORIC or OBSOLETE.
  DBERR_BOMITEMSEXIST            CONSTANT NUMBER := 80; --There are still items in this bom.
  DBERR_BOMITEMSSTATUSEQCURRENT  CONSTANT NUMBER := 317; --BOM ITEMS have status type equal to CURRENT or APPROVED for spec %1 %2.
  DBERR_BOMITEMUOMDIFFFROMPART   CONSTANT NUMBER := 329; --One of the bom items has a uom that is different from what is defined against the part.
  DBERR_BOMPATHNOTFOUND          CONSTANT NUMBER := 144; --No Data Found in ItBomPath for ID %1.
  DBERR_BOMSNOTINSYNC            CONSTANT NUMBER := 402; --The following BoMs are not In Sync. anymore: %1
  DBERR_BOMUSAGENOTFOUND         CONSTANT NUMBER := 364; --BoM Usage <%1> is not found.
  DBERR_CANNOTCHANGEPEDDATE      CONSTANT NUMBER := 156; --You cannot change the effective date of a Specification which is in a PED group.
  DBERR_CFGPARAMVALUEERROR       CONSTANT NUMBER := 108; --System setting parameter %1 should be %2
  DBERR_CHARACTERISTICNOTFOUND   CONSTANT NUMBER := 112; --Characteristic <%1> is not found.
  DBERR_CHARNOTASSIGNEDTOASS     CONSTANT NUMBER := 306; --Characteristic <%1> not assigned to association.
  DBERR_CLAIMLOGNOTFOUND         CONSTANT NUMBER := 193; --ClaimLog %1 Not Found.
  DBERR_CLAIMLOGRESALREADYEXISTS CONSTANT NUMBER := 195; --Claim Log Result already exists for Log Id %1, Property Group %2 and Property %3
  DBERR_CLASSIFICATIONNOTFOUND   CONSTANT NUMBER := 90; --Classification for partno  <%1> does not exist.
  DBERR_CODEISMANDATORY          CONSTANT NUMBER := 424; --The code is mandatory.
  DBERR_COMPONENTNOTEXIST        CONSTANT NUMBER := 368; --Component %1 [%2] does not exist.
  DBERR_COMPWITHOUTSPECAPPROVED  CONSTANT NUMBER := 321; --Component Part %1, Revision %2 do NOT have specification which is APPROVED or CURRENT.
  DBERR_CONFIGPARAMNOTFOUND      CONSTANT NUMBER := 220; --Parameter %1, Section %2 not found in configuration.
  DBERR_CONFIGPARAMVALUENOTFOUND CONSTANT NUMBER := 221; --Parameter value must be specified for parameter %1 and section %2 in configuration table.
  DBERR_CONVFACTORISMANDATORY    CONSTANT NUMBER := 430; --The conversion factor is mandatory.
  DBERR_CURRENTREVISIONNOTFOUND  CONSTANT NUMBER := 139; --Current Part-Revision not found for Ref Type %1 .
  DBERR_CUSTOMPROCERROR          CONSTANT NUMBER := 230; --Following error <%1> occured while executing custom procedure <%2> for standard function <%3>.
  DBERR_DATEMUSTBEGTTHANPREVREV  CONSTANT NUMBER := 153; --Date must be in the future and greater than the date of a previous revision.
  DBERR_DATEMUSTBEGTTODAY        CONSTANT NUMBER := 151; --Date must be greater than TODAY
  DBERR_DATEMUSTBELTTHANNEXTREV  CONSTANT NUMBER := 154; --Date must be less than the date of a next revision.
  --AP01460559
  DBERR_DELACTIVEUSER    CONSTANT NUMBER := 499; --Cannot delete a user that is logged in another session.
  DBERR_DELSPECINATTSPEC CONSTANT NUMBER := 399; --Cannot delete a specification %1 [%2] that is referenced as an attached specification.
  DBERR_DELSPECINBOM     CONSTANT NUMBER := 398; --Cannot delete a specification %1 [%2] that is already part of a Bom.  Use the WHERE USED enquiry screen to identify which Bom.
  DBERR_DELUOMGROUPUSED  CONSTANT NUMBER := 480; --Cannot delete a uom group hat is already assingned for the Uom.
  DBERR_DELUSEINBOM      CONSTANT NUMBER := 397; --Not allowed to delete the specification %1 [%2] because it is explicit used in a Bom.
  --AP00977782
  DBERR_DELSPECINPROCLINESTAGE  CONSTANT NUMBER := 490; --Cannot be deleted the specification %1 because it is referenced as part in a specification Process Stage.
  DBERR_DESCREMPTY              CONSTANT NUMBER := 250; --Description is empty
  DBERR_DESCRIPTIONALREADYEXIST CONSTANT NUMBER := 102; --Description %1 already exist.
  DBERR_DESCRNOTUNIQUE          CONSTANT NUMBER := 251; --Description is not unique
  DBERR_DISPLAYFORMATINVALID    CONSTANT NUMBER := 443; --Display format id <%1> invalid for %2.
  DBERR_DUPLICATEBOMITEM        CONSTANT NUMBER := 372; --Bom item already exists for - %1 - %2 - %3 - %4 - %5 - %6 - %7.
  DBERR_DUPLICATECLASSIFICATION CONSTANT NUMBER := 91; --Classification for  partno <%1>, level <%2>, material class id <%3>, classification code <%4> and classification type <%5> already exists.
  DBERR_DUPLICATEEVENTSERVICE   CONSTANT NUMBER := 293; --Event  Service %1 already exists.
  DBERR_DUPLICATEKEYWORDVALUE   CONSTANT NUMBER := 58; --Keyword <%2> with value <%3> already belongs to part <%1>
  DBERR_DUPLICATEPARTMFC        CONSTANT NUMBER := 74; --Part maufacturer relation for partno <%1>, manufacturerid <%2> and manufacturerplantno already exists.
  DBERR_DUPLICATEPARTPLANT      CONSTANT NUMBER := 78; --Part plant relation for partno <%1> and plant <%2> already exists.
  DBERR_DUPLICATESPDLINE        CONSTANT NUMBER := 118; --Process data line %1, already exists for specification %2 [%3] for plant %4 and configuration %5
  DBERR_DUPLICATESPDLINESTAGE   CONSTANT NUMBER := 119; --Process data line stage already exists for specification %1 [%2] for plant %3, line %4 and configuration %5
  --AP01329469
  DBERR_DUPLICATESPDSTAGEASSOC   CONSTANT NUMBER := 500; --Process data line stage property-assotiation already exists for specification %1 [%2] for plant %3, line %4, configuration %5 and stage
  DBERR_DUPLICATESPDSTAGEDATA    CONSTANT NUMBER := 120; --Process data line stage property/item/text already exists for specification %1 [%2] for plant %3, line %4, configuration %5 and stage
  DBERR_DUPVALONINDEX            CONSTANT NUMBER := 31; --A record with this key already exists.
  DBERR_EFFDATELOWERTHANSPECPED  CONSTANT NUMBER := 421; --Effective Date must not be lower than the Specification Header Planned Effective Date.
  DBERR_ELEMENTNOTFOUNDINXML     CONSTANT NUMBER := 188; --Element <%1> Not Found In  Xml Document
  DBERR_EMAILSNOTPROCESSED       CONSTANT NUMBER := 309; --[%1] e-mail message(s) have not been processed.
  DBERR_ERRMATCHBOMITEMANDHEADER CONSTANT NUMBER := 316; --Error trying to match BOM HEADER and BOM ITEM for spec %1 %2.
  DBERR_ERRORLIST                CONSTANT NUMBER := 54; --A list of errors is generated.
  DBERR_ERRSYNCPART              CONSTANT NUMBER := 387; --Error synchronising part %1. Please look to error log for more details.
  DBERR_EVENTLOGEXIST            CONSTANT NUMBER := 484; --Event log for event id [%1] transmission type [%2]  already exists.
  DBERR_EVENTLOGNOTFOUND         CONSTANT NUMBER := 483; --Event log for event id [%1] transmission type [%2]  does not exists.
  DBERR_EVENTSERVICETYPENOTFOUND CONSTANT NUMBER := 487; --No Event Type found for Event Service [%1].
  DBERR_EVENTTYPENOTFOUND        CONSTANT NUMBER := 486; --Event type [%1] does not exists.
  DBERR_EXEMPTIONNOTEXIST        CONSTANT NUMBER := 442; --Exemption % 2 for part %1 does not exist.
  DBERR_EXPLOSIONINCOMPLETE      CONSTANT NUMBER := 106; --The bom explosion of specification %1 [%2]  on the selected date is incomplete. To see the items where the revision number could not be determined, please use the standard explosion.
  DBERR_EXPLOSIONNOACCESS        CONSTANT NUMBER := 105; --You do not have access to 1 or more items in the bom explosion of specification %1 [%2] on the selected date. To see which items are not accessible, please use the standard explosion.
  DBERR_FILEERRORNOTAB           CONSTANT NUMBER := 258; --Problem with (transfered) file -> no TAB characters available
  DBERR_FILENAMEEMPTY            CONSTANT NUMBER := 252; --File name is empty
  DBERR_FLAGAPPROVENOTEQUALPF    CONSTANT NUMBER := 277; --Approve not equal to P or F
  DBERR_FOODCLAIMLOGRESDETEXISTS CONSTANT NUMBER := 452; --Food Claim Log Result Detail record already exist for Log Id <%1>, Food Claim Id <%2>, Food Claim Criteria Rule Cd Id <%3>, Hier Level <%4>,Nutritional Log Id = <%5>.
  DBERR_FOODCLAIMLOGRESULTEXISTS CONSTANT NUMBER := 451; --Food Claim Log Result record already exist for Log Id <%1>, Food Claim Id <%2>, Nutritional Log Id = <%3>.
  DBERR_FOODCLAIMMULTRULESFOUND  CONSTANT NUMBER := 462; --Multiple rules found.
  DBERR_FOODCLAIMNORULESFOUND    CONSTANT NUMBER := 461; --No rules found.
  DBERR_FOODCLAIMNOTFOUND        CONSTANT NUMBER := 454; --Food Claim with Log Id <%1> not found.
  DBERR_FOODCLAIMNOTSATISFIED    CONSTANT NUMBER := 460; --Food claim not satisfied.
  DBERR_FOODCLAIMRECURSIVE       CONSTANT NUMBER := 459; --Food Claim is recursive.
  DBERR_FOUNDINVALIDCHARSINPLANT CONSTANT NUMBER := 121; --Unable to create the plant %1 because there are one or more invalids characters found in the name.
  DBERR_FPBOMHEADERSUMNOT100     CONSTANT NUMBER := 319; --The sum of the FP bom header not 100 for spec %1 %2.
  DBERR_FPBOMITEMSUMNOT100       CONSTANT NUMBER := 318; --The sum of the FP bom item is not 100 for spec %1 %2.
  DBERR_FPBOMITEMSUOMNOTALLEQ    CONSTANT NUMBER := 320; --The uom of the bom items are not all the same for spec %1 %2.
  DBERR_FRAMEALREADYEXIST        CONSTANT NUMBER := 379; --Frame already exists. Please use the copy functionality to create a new revision.
  DBERR_FRAMEIDNOTFOUND          CONSTANT NUMBER := 359; --Id <%6> not found in frame <%1-%2-%3-%4-%5>
  DBERR_FRAMEIDTOOLONG           CONSTANT NUMBER := 259; --Frame ID is too long (max 18 characters)
  DBERR_FRAMEINDEVALREADYEXIST   CONSTANT NUMBER := 380; --A version in development already exists for Frame %1 Owner %2.
  DBERR_FRAMEINTLCANNOTCOPYONTO  CONSTANT NUMBER := 383; --You cannot copy onto intl Frame
  DBERR_FRAMEISMANDATORY         CONSTANT NUMBER := 426; --The frame is mandatory.
  --AP01459527 Start
  --DBERR_FRAMEITEMHIDDEN CONSTANT NUMBER := 43;   --Due to the applied mask (%8), item %7 (%6) is hidden in Frame section %1-%2-%3-%4-%5.
  DBERR_FRAMEITEMHIDDEN CONSTANT NUMBER := 43; --Due to the applied mask (%7), item %6 is hidden in Frame section %1-%2-%3-%4-%5.
  --AP01459527 End
  --AP01459527 Start
  --DBERR_FRAMEITEMNOTFOUND CONSTANT NUMBER := 39;   --Item %7 (%6) not found in Frame section %1-%2-%3-%4-%5 --orig
  DBERR_FRAMEITEMNOTFOUND CONSTANT NUMBER := 39; --Item %6 not found in Frame section %1-%2-%3-%4-%5
  --AP01459527 End
  DBERR_FRAMEMASKMANDATORY    CONSTANT NUMBER := 437; --The frame mask is mandatory.
  DBERR_FRAMEMASKNOTEXIST     CONSTANT NUMBER := 436; --The frame mask %1 does not exist for frame %2, revision %3, owner %4.
  DBERR_FRAMENOISNOTCURRENT   CONSTANT NUMBER := 433; --The frame %1, revision %2, owner %3 is not current.
  DBERR_FRAMENOTCURRENT       CONSTANT NUMBER := 358; --Frame %1 is not Current for %2.
  DBERR_FRAMENOTFOUND         CONSTANT NUMBER := 37; --Frame %1 [%2] owner %3 is not found
  DBERR_FRAMENOTINTERNATIONAL CONSTANT NUMBER := 432; --The frame %1, revision %2, owner %3 is not an international frame.
  DBERR_FRAMEOUTOFDATE        CONSTANT NUMBER := 393; --The frame is out of date.
  --AP01459527 Start
  --DBERR_FRAMESECTIONNOTFOUND CONSTANT NUMBER := 38;   --Frame %1 [%2] section %3-%4-%5 is not found. --orig
  DBERR_FRAMESECTIONNOTFOUND CONSTANT NUMBER := 38; --Frame %1 [%2]-%3 section %4-%5 is not found.
  --AP01459527 End
  DBERR_FRAMESNOTPROCESSED       CONSTANT NUMBER := 311; --[%1] frame(s) have not been processed.
  DBERR_FRAMESYNCDIFFERENTID     CONSTANT NUMBER := 384; --You can only sync frames with same ID.
  DBERR_FREETEXTIDNOTFNDFORDESC  CONSTANT NUMBER := 413; --Free text Id not found for description %1.
  DBERR_FREETEXTNOTFILLEDIN      CONSTANT NUMBER := 336; --Free text not filled in.
  DBERR_FRPROPERTYNOTFOUND       CONSTANT NUMBER := 101; --Property/attribute <%7/%8> not found in property group <%6> in frame section <%1-%2-%3-%4-%5>
  DBERR_FUNCTIONNOTFOUND         CONSTANT NUMBER := 192; --Function <%1> used by Nutritional Layout <%2> is not found in Database. Please check the Layout item Calculation Method.
  DBERR_GENFAIL                  CONSTANT NUMBER := 1; --A general failure occurred in the database. Please refer to the error logging for more information.
  DBERR_GLBAUTHENTICATIONNOTCONF CONSTANT NUMBER := 448; --Database not configured for Global Authentication.
  DBERR_HARMBOMHIGHERVERSION     CONSTANT NUMBER := 331; --Harm BOM higher version for part %1, revision %2.
  DBERR_HARMINTLBOM              CONSTANT NUMBER := 4; --The international bom of a localised specification %1 [%2] cannot be changed.
  DBERR_HEADERNOTFOUND           CONSTANT NUMBER := 362; --Header <%1> is not found.
  DBERR_INCOMPATIBLEPARAMETERS   CONSTANT NUMBER := 449; --Parameter 1% incompatible with 2%.
  DBERR_INGCOMPLISTNOTFOUND      CONSTANT NUMBER := 340; --Ingredient Component List not found.
  --IS1031 --onLine
  DBERR_INGDETAILASSOCINUSE      CONSTANT NUMBER := 502; --Ingredient detail association cannot be changed because it is in use.
  DBERR_INGHEADERCLEARNRNOTALLOW CONSTANT NUMBER := 330; --It is not allowed to use the header to fill in a clearance number for a specification of type ING.
  DBERR_INGREDIENTNOTEXIST       CONSTANT NUMBER := 349; --Ingredient %1 does not exist.
  DBERR_INTEGRITYVIOLATION       CONSTANT NUMBER := 150; --Cannot copy Specification. Integrity violation happened on  %1.
  DBERR_INTLPARTHARMBOM          CONSTANT NUMBER := 114; --Prior to submission of this harmonised BoM,  bom item %1 must be a localised equivalent or a local part.
  DBERR_INTLPARTHARMBOMEQ        CONSTANT NUMBER := 115; --Prior to submission of this harmonised bom, bom item %1 must be a localised equivalent.
  DBERR_INTLPARTNOTCURRENT       CONSTANT NUMBER := 386; --International part %1 has no current revision.
  DBERR_INVALIDACCESS            CONSTANT NUMBER := 161; --ACCESS cannot be NULL
  DBERR_INVALIDACCESSPRIVS       CONSTANT NUMBER := 170; --You must have edit access to the original access group to make a new revision.
  DBERR_INVALIDACTION            CONSTANT NUMBER := 89; --Invalid action <%1> specified
  DBERR_INVALIDALTGROUP          CONSTANT NUMBER := 61; --Wrong Bom Item Alternative Group.
  DBERR_INVALIDALTPRIORITY       CONSTANT NUMBER := 62; --Wrong Bom Item Alternative Priority.
  DBERR_INVALIDANYHOOKTYPE       CONSTANT NUMBER := 46; --The specified section item type %1 is not valid for using the <ANY>-hook functionality; it has either to be an OBJECT or a REFERENCE TEXT.
  DBERR_INVALIDAPPLICATIONUSER   CONSTANT NUMBER := 24; --User %1 is not a valid application user.
  DBERR_INVALIDBOMALTSEQ         CONSTANT NUMBER := 69; --New Bom alternatives must in successive order.
  DBERR_INVALIDBOMDFSTATUS       CONSTANT NUMBER := 129; --Development Version of BOM Display Format already exist for ID %1 and Revision %2.
  DBERR_INVALIDBOMUSAGE          CONSTANT NUMBER := 70; --Invalid Bom Usage.
  DBERR_INVALIDCALCFORALTITEM    CONSTANT NUMBER := 204; --Calculation cannot be flagged for Alternative Bom item
  --AP01367955 oneLine
  DBERR_INVALIDCALCMODE         CONSTANT NUMBER := 498; --For Bom Item <%1> the specified Calculation Mode <%2> is not allowed.
  DBERR_INVALIDCALCQUANTITY     CONSTANT NUMBER := 225; --Calculated Quantities for the BoM explosion are larger than allowed Limit.
  DBERR_INVALIDCASESENSITIVEPAR CONSTANT NUMBER := 201; --Invalid option given for Case Sensitive parameter <%1>.
  DBERR_INVALIDDAY              CONSTANT NUMBER := 168; --Invalid DAY
  DBERR_INVALIDDFSTATUS         CONSTANT NUMBER := 131; --Development Version of Display Format already exist for ID %1 and Revision %2.
  DBERR_INVALIDEMAILADDRESS     CONSTANT NUMBER := 310; --User <%1> has an invalid e-mail address.
  --AP00961430 --AP00972365
  DBERR_INVALIDEMAILADDRESS2 CONSTANT NUMBER := 492; --The e-mail address <%1> is invalid (In interspc6.3HF14 the error code was 472).
  --AP01117286
  DBERR_INVALIDEMAILADDRESS3     CONSTANT NUMBER := 496; --The e-mail address <%1> is invalid or does not exist
  DBERR_INVALIDFILTER            CONSTANT NUMBER := 26; --Invalid filter %1
  DBERR_INVALIDFIXEDQUANTITY     CONSTANT NUMBER := 376; --Invalid value <%1> given for fixed quantity.
  DBERR_INVALIDFRAME             CONSTANT NUMBER := 159; --FRAME cannot be NULL.
  DBERR_INVALIDHARMBOMEQ         CONSTANT NUMBER := 116; --An international equivalent can only exist in bom items of a localised or international specification.
  DBERR_INVALIDINTLPARTSTATUS    CONSTANT NUMBER := 152; --International Part is not Current
  DBERR_INVALIDLANGUAGE          CONSTANT NUMBER := 79; --Invalid language <%1>.
  DBERR_INVALIDLEVELPID          CONSTANT NUMBER := 226; --Invalid Parent ID <%1> Hierarchial Level <%2> combination.
  DBERR_INVALIDLICENSE           CONSTANT NUMBER := 1101; --You have an invalid SIMATIC IT Interspec license. Please contact your Siemens partner to acquire a valid license.
  DBERR_INVALIDLIMIT             CONSTANT NUMBER := 239; --Property validation failed, value should be between lower and upper reject value.
  DBERR_INVALIDMARKUPANDCALCMODE CONSTANT NUMBER := 229; --Make-Up can be marked only when CalculationMode is Q or B.
  DBERR_INVALIDMARKUPANDUOM      CONSTANT NUMBER := 228; --Make-Up cannot be marked when item UOM and Base UOM is not of the same UOM Group.
  DBERR_INVALIDMARKUPFORALTITEM  CONSTANT NUMBER := 205; --Make-Up cannot be marked for Alternative Bom item
  DBERR_INVALIDMINMAXQTY         CONSTANT NUMBER := 75; --Quantity must be between minimum and maximum.
  DBERR_INVALIDMONTH             CONSTANT NUMBER := 167; --Invalid MONTH
  DBERR_INVALIDMOPPARAMTER       CONSTANT NUMBER := 202; --Invalid option given for Use MOP parameter <%1>.
  DBERR_INVALIDNEWREVISION       CONSTANT NUMBER := 163; --New Revision cannot be NULL
  --AP01058317 --AP01054597
  DBERR_INVALIDNUTCOLID    CONSTANT NUMBER := 494; --If Nutritional Profile is selected to be used then a Column has to be selected.
  DBERR_INVALIDNUTDFSTATUS CONSTANT NUMBER := 147; --Development Version of Nutritional Display Format already exist for ID %1 and Revision %2.
  --AP01058317 --AP01054597
  DBERR_INVALIDNUTPROFILEID     CONSTANT NUMBER := 493; --If Nutritional Profile is selected to be used then a Profile has to be selected.
  DBERR_INVALIDNUTXML           CONSTANT NUMBER := 186; --Nutritional XML can not be NULL for AddAdditionalXML.
  DBERR_INVALIDOPERATOR         CONSTANT NUMBER := 25; --Invalid operator %1
  DBERR_INVALIDPART             CONSTANT NUMBER := 29; --Invalid Part Number.
  DBERR_INVALIDPARTNO           CONSTANT NUMBER := 158; --PART NO cannot be NULL
  DBERR_INVALIDPARTREVCOMP      CONSTANT NUMBER := 149; --Invalid Part (%1) and Revision (%2) combination in Original Spec.
  DBERR_INVALIDPARTTYPE         CONSTANT NUMBER := 83; --Part type <%1> does not exist.
  DBERR_INVALIDPED              CONSTANT NUMBER := 72; --Effective Date must be in the future.
  DBERR_INVALIDPG               CONSTANT NUMBER := 87; --Invalid property group <%1>.
  DBERR_INVALIDPGDF             CONSTANT NUMBER := 84; --Invalid display format <%2> for property group <%1>.
  DBERR_INVALIDPLANEFFDATE      CONSTANT NUMBER := 162; --Planned Effective Date cannot be NULL
  DBERR_INVALIDPREFERREDFLAG    CONSTANT NUMBER := 68; --Must have 1 and only 1 one preferred record.
  DBERR_INVALIDPRESPECSEQUENCE  CONSTANT NUMBER := 157; --The previous Specifications are not in the correct revision sequence.
  DBERR_INVALIDPRICETYPE        CONSTANT NUMBER := 99; --The price type %1 does not exist.
  DBERR_INVALIDPROP             CONSTANT NUMBER := 9; --Invalid property <%1>.
  DBERR_INVALIDPROPATT          CONSTANT NUMBER := 96; --Invalid attribute <%2> for property <%1>.
  DBERR_INVALIDPROPDF           CONSTANT NUMBER := 8; --Invalid display format <%2> for property <%1>.
  DBERR_INVALIDQUANTITY         CONSTANT NUMBER := 224; --BOM Item Quantity cannot be Null.
  DBERR_INVALIDROUNDRULESETTING CONSTANT NUMBER := 198; --Invalid Rounding Rule setting in Nutritional Reference for Ref-Type<%1>.
  --AP01318780 Start
  --DBERR_INVALIDSCRAP   CONSTANT NUMBER := 6;   --The scrap factor must be between 0 and 100. --orig
  DBERR_INVALIDSCRAP CONSTANT NUMBER := 6; --The scrap factor must be greater or equal to 0
  --AP01318780 End
  DBERR_INVALIDSEARCHOPTION CONSTANT NUMBER := 203; --Invalid option given for Search type  <%1>.
  DBERR_INVALIDSPECSTATUS   CONSTANT NUMBER := 164; --A specification for this part already exists in the development cycle with a status type of DEVELOPMENT. Two specifications for the same part cannot exist in development.
  DBERR_INVALIDSPECSTATUS2  CONSTANT NUMBER := 165; --A specification for this part already exists in the development cycle with a status type of REJECT. Two specifications for the same part cannot exist in the development cycle.
  DBERR_INVALIDSPECSTATUS3  CONSTANT NUMBER := 166; --A specification for this part already exists in the development cycle with a status type of SUBMIT. Two specifications for the same part cannot exist in the development cycle.
  DBERR_INVALIDTCINPROGRESS CONSTANT NUMBER := 472; --Invalid TC in progress number.
  DBERR_INVALIDUOMCOMPONENT CONSTANT NUMBER := 369; --Invalid UoM %1 for Component %2.
  DBERR_INVALIDVALIDATION   CONSTANT NUMBER := 408; --Property validation failed for function <%1>.
  DBERR_INVALIDWORKFLOW     CONSTANT NUMBER := 160; --WORKFLOW cannot be NULL
  DBERR_ISMANDATORY         CONSTANT NUMBER := 51; --%1 is mandatory
  --AP01459527 Start
  --DBERR_ITEMALREADYINSECTION CONSTANT NUMBER := 53;   --Item is already in section %1 [%2] (%3,%4) --orig
  DBERR_ITEMALREADYINSECTION CONSTANT NUMBER := 53; --Item %5 is already in section %1 [%2] (%3,%4)
  --AP01459527 End
  DBERR_ITEMINFRAMESECTION     CONSTANT NUMBER := 88; --Item is already available in the frame <%1-%2-%3>, section <%4-%5>.
  DBERR_ITEMNOTLOCALMODIFIABLE CONSTANT NUMBER := 394; --Item is not locally modifiable.
  --IS1031 --oneLine
  DBERR_ITEMNOTFOUND             CONSTANT NUMBER := 501; --%1 with id <%2> not found.
  DBERR_JOBNOTFOUND              CONSTANT NUMBER := 113; --Job not found.
  DBERR_KEYWORDLISTEXIST         CONSTANT NUMBER := 307; --Cannot change list with characteristics is assigned to keyword %1.
  DBERR_KEYWORDNOTFOUND          CONSTANT NUMBER := 77; --Keyword %1 is not found.
  DBERR_KEYWORDVALUENOTFOUND     CONSTANT NUMBER := 347; --Keyword value %1 does not exist for the keyword %2.
  DBERR_LABELNOTFOUND            CONSTANT NUMBER := 453; --Label not found for LogId <%1>.
  DBERR_LICENSEEXPIRED           CONSTANT NUMBER := 1102; --Your SIMATIC IT Interspec license has expired. Please contact your Siemens partner to acquire a new one.
  DBERR_LICENSEINVALIDKEY        CONSTANT NUMBER := 21; --Incorrect or missing license key. Please update your license as soon as possible.
  DBERR_LICENSETOOMANYUSERS      CONSTANT NUMBER := 22; --There are more users active than specified in the license agreement. Please update your license as soon as possible.
  DBERR_LOCALFRAMECOPYBYINTLUSER CONSTANT NUMBER := 382; --Local frame copied by an intl user : should not be possible.
  DBERR_LOCALPARTNOTEXIST        CONSTANT NUMBER := 385; --Local part %1 does not exist.
  DBERR_LOCALWARNING             CONSTANT NUMBER := 392; --Local error warning.
  DBERR_MANDATORYFIELDCREATESPEC CONSTANT NUMBER := 172; --Not all Mandatory fields are having values : PART NO (%1), REVISION (%2),STATUS (%3),FRAME (%4),WORKFLOW (%5), ACCESS (%6), DATE (%7)
  DBERR_MANUALCONDNOTFOUND       CONSTANT NUMBER := 464; --Manual Condition not found.
  DBERR_MANUALCONDNOTSATISFIED   CONSTANT NUMBER := 455; --Manual condition not satisfied.
  DBERR_MANUFACTURERNOTFOUND     CONSTANT NUMBER := 48; --Manufacturer %1 is not found
  DBERR_MANUFACTURPLANTNOTFOUND  CONSTANT NUMBER := 49; --Manufacturer-plant (%1,%2) is not found
  DBERR_MANYBOMITEMDISPLAYFORMAT CONSTANT NUMBER := 374; --Too many bom item display format found - %1 - %2 - %3.
  DBERR_MAPPINGNOTFOUND          CONSTANT NUMBER := 180; --Mapping not found.
  DBERR_MAPPINGNOTFOUND2         CONSTANT NUMBER := 181; --Mapping not found.
  DBERR_MASKNOTFOUND             CONSTANT NUMBER := 410; --Mask %1 not found for frame %2, revision %3 and owner %4.
  DBERR_MISSINGERRDESC           CONSTANT NUMBER := 30; --The error description for error number %1 is not configured.
  DBERR_MISSINGPARAMORSECTION    CONSTANT NUMBER := 2; --Either Section %1 or Parameter %2 in the section does not exist
  DBERR_MOLEXPLOSIONINCOMPLETE   CONSTANT NUMBER := 213; --The bom explosion on the selected date is incomplete. To see the items where the revision number could not be determined, please use the standard explosion.
  DBERR_MORETHANONECRITERIAFOUND CONSTANT NUMBER := 457; --More than one criteria satisfies keyword
  DBERR_MORETHANONECURRENTFRAME  CONSTANT NUMBER := 419; --There is more than one current revision of the frame %1.
  DBERR_NEWPLANTPEDGTCURRPED     CONSTANT NUMBER := 401; --The new effective date is greater than one or more plant effective dates of this revision.
  DBERR_NEWPLANTPEDLTPREVPED     CONSTANT NUMBER := 400; --The new effective date is less than one or more plant effective dates of a prior revision.
  DBERR_NOACCESSSETCONNECTION    CONSTANT NUMBER := 314; --You do not have the required access privileges to set connection to user %1.
  DBERR_NOACCESSSPEC             CONSTANT NUMBER := 389; --You do not have the correct level of access to the specification.
  DBERR_NOAUTOCALC               CONSTANT NUMBER := 377; --No Auto Calc allowed for Component %1.
  DBERR_NOBASEQUANTITY           CONSTANT NUMBER := 222; --Cannot explode the BOM since Base Quantity is 0 for Part %1 [%2], Plant %3, Alternative %4 and Usage %5.
  DBERR_NOBOMHEADER              CONSTANT NUMBER := 32; --The bom header of specification %1 [%2] , plant %3 alternative %4 usage %5 does not exist.
  DBERR_NOBOMINFRAME             CONSTANT NUMBER := 366; --BoM is not found in frame <%1>.
  DBERR_NOBOMITEM                CONSTANT NUMBER := 98; --The bom item of specification %1 [%2] , plant %3 alternative %4 usage %5 and item number %6 does not exist.
  DBERR_NOBOMITEMDISPLAYFORMAT   CONSTANT NUMBER := 373; --No bom item display format found - %1 - %2 - %3.
  DBERR_NOBOMITEMGROUPPRIO       CONSTANT NUMBER := 97; --The bom item of specification %1 [%2] , plant %3 alternative %4 usage %5 does not exist with groupname %6 and priority %7.
  DBERR_NOCRITERIAFOUND          CONSTANT NUMBER := 458; --No criteria found for claim.
  DBERR_NOCUSTOMFUNCTION         CONSTANT NUMBER := 19; --No custom %3 function configured for %2 out of %1
  DBERR_NODASHALLOWED            CONSTANT NUMBER := 431; --A local part may not contain a dash as 4th character when the 3-tier db parameter is set.
  DBERR_NODISPLAYFRMTFOUND       CONSTANT NUMBER := 375; --Display Format not found for Part %1, Revision %2, Section Id %3, SubSection Id %4, Property Group Id %5, Property Id %6, Attribute Id %7.
  DBERR_NODISPLAYFRMTFOUNDLAYOUT CONSTANT NUMBER := 130; --Display Format not found for Layout ID %1 and Revision %2.
  DBERR_NODISPLAYFRMTFOUNDPART   CONSTANT NUMBER := 468; --Display Format not found for Part %1.
  DBERR_NOEDITSECTIONACCESS      CONSTANT NUMBER := 294; --No edit access on specification %1 [%2] section %3-%4-%5.
  DBERR_NOERRORINLIST            CONSTANT NUMBER := 190; --No messages of type ERROR in the errorlist.
  DBERR_NOINITSESSION            CONSTANT NUMBER := 100; --This database session has not correctly been initialised. Please use SetConnection to correct the problem.
  DBERR_NOINSERTBOMITEM          CONSTANT NUMBER := 371; --Unable to insert bom item  - %1 - %2 - %3 - %4 - %5 - %6 - %7.
  DBERR_NOLICENSE4APP            CONSTANT NUMBER := 1103; --You do not have the right SIMATIC IT Interspec license. Please contact your Siemens partner to acquire a license.
  DBERR_NOMRPACCESS              CONSTANT NUMBER := 18; --You have no MRP access rights.
  DBERR_NOORMORELOCVERSIONSFOUND CONSTANT NUMBER := 235; --The bom item %1 was copied but could not be replaced by a localised equivalent because there are no or more than 1 localised versions found.
  DBERR_NOPARTID                 CONSTANT NUMBER := 40; --Part number is not specified.
  DBERR_NOPARTPLANT              CONSTANT NUMBER := 33; --No or obsolete relationship found between part %1 and plant %2.
  DBERR_NOPARTPLANTFORBOMITEM    CONSTANT NUMBER := 233; --There is no Part Plant relationship for the item %1
  DBERR_NOPARTPLANTFORHARBOMITEM CONSTANT NUMBER := 232; --The bom item %1 was copied but could not be replaced by a localised equivalent because there was no (or obsolete) plant relation.
  DBERR_NORECORDS                CONSTANT NUMBER := 219; --You have no SIMATIC IT Interspec license. Please contact your Siemens partner to acquire license.
  DBERR_NOROUNDFUNCTIONMAPPING   CONSTANT NUMBER := 199; --Could not find a Rounding Function for Charactertistic ID<%1>, in itnutrounding.
  DBERR_NOSAVEALLOWED            CONSTANT NUMBER := 44; --Save Data not allowed when specification %1 [%2] is no longer in development.
  DBERR_NOSTATUSCHANGECUSTOMCODE CONSTANT NUMBER := 485; --No custom code configured for workflow group %1 and status %2.
  DBERR_NOTBOOLEAN               CONSTANT NUMBER := 185; --Not a Boolean(%1). Value must be 1 or 0.
  DBERR_NOTCORRECTACCESSRIGHT    CONSTANT NUMBER := 422; --You do not have the correct access right.
  DBERR_NOTHINGTOPERFORM         CONSTANT NUMBER := 407; --Nothing to perform, no action required.
  DBERR_NOTLOCALISED             CONSTANT NUMBER := 50; --Specification %1 [%2] is not localised
  DBERR_NOTLOCALLYMODIFIABLE     CONSTANT NUMBER := 42; --Item %6 [%5] is not locally modifiable for specification section %1-%2-%3-%4
  DBERR_NOTNUMERIC               CONSTANT NUMBER := 182; --%1 is not a valid Number.
  DBERR_NOTVALIDDATE             CONSTANT NUMBER := 183; --The date %1 is not a valid date.
  DBERR_NOTVALIDSTRING           CONSTANT NUMBER := 184; --Length of String exceeds the limit of %1.
  DBERR_NOUPDATEACCESS           CONSTANT NUMBER := 17; --No update access on specification %1 [%2].
  DBERR_NOUPDATEACCESSGROUP      CONSTANT NUMBER := 439; --No update access to the access group.
  DBERR_NOUPDATEBOMITEM          CONSTANT NUMBER := 370; --Unable to update bom item  - %1 - %2 - %3 - %4 - %5 - %6 - %7.
  DBERR_NOUPDATEINTERNATIONAL    CONSTANT NUMBER := 391; --As a local user you cannot update international specifications.
  DBERR_NOUPDATELOCAL            CONSTANT NUMBER := 390; --As an international user you cannot update local specifications.
  DBERR_NOUPDATEWORKFLOWGROUP    CONSTANT NUMBER := 438; --No update access to the workflow group.
  DBERR_NOVIEWACCESS             CONSTANT NUMBER := 16; --No view access on specification %1 [%2].
  DBERR_NOVIEWBOMACCESS          CONSTANT NUMBER := 86; --User %1 has no view bom access.
  DBERR_NOVIEWSECTIONACCESS      CONSTANT NUMBER := 255; --No view access on specification %1 [%2] section %3-%4-%5.
  DBERR_NUMINCORRECTCHAR         CONSTANT NUMBER := 176; --Part Code starts with incorrect character
  DBERR_NUMINCORRECTCHARS        CONSTANT NUMBER := 178; --Part Code starts with incorrect set of characters
  DBERR_NUMINVALIDCHAR           CONSTANT NUMBER := 177; --Part Code has invalid character
  DBERR_NUMNOTALLOWED            CONSTANT NUMBER := 179; --Not allowed to create local Part codes
  DBERR_NUMNOTNUMERIC            CONSTANT NUMBER := 175; --Part Code is not numeric and thus out of range
  DBERR_NUMOUTOFMANRANGE         CONSTANT NUMBER := 174; --You are not allowed to create a part code within the internal automated part code range.
  DBERR_NUMOUTOFRANGE            CONSTANT NUMBER := 173; --You are not allowed to create a part code within the ERP (common-coded) part code range.
  DBERR_NUTDFEXIST               CONSTANT NUMBER := 210; --Nutritional Display Format already exists with Layout ID %1 and Revision %2.
  DBERR_NUTDFNOTFOUND            CONSTANT NUMBER := 146; --Nutritional Display Format not found for Layout ID %1 and Revision %2.
  DBERR_NUTEXPNOTFOUND           CONSTANT NUMBER := 191; --Nutritional Explosion not found for ID %1 MopSequence %2 and RowID %3.
  DBERR_NUTEXPPANNOTFOUND        CONSTANT NUMBER := 145; --Nutritional Exported Panels not found for ID %1 and Sequence %2.
  DBERR_NUTEXPPANNOTFOUND2       CONSTANT NUMBER := 148; --Development Version of Nutritional Display Format already exist for ID %1.
  DBERR_NUTFILTERNAMEFOUND       CONSTANT NUMBER := 134; --Nutritional Filter %1 already exist for ID %2.
  DBERR_NUTFILTERNOTFOUND        CONSTANT NUMBER := 133; --Nutritional Filter not found for ID %1.
  --AP00848542
  DBERR_NUTLOGNOTFOUND           CONSTANT NUMBER := 488; --Nutritional Log not found for ID %1.
  DBERR_NUTLOGRESALREADYEXISTS   CONSTANT NUMBER := 196; --Nutritional Log Result already exists for Log Id %1, ColId %2 and RowId %3
  DBERR_NUTLOGRESDETALREADYEXIST CONSTANT NUMBER := 197; --Nutritional Log Result Detail already exists for Log Id %1, ColId %2, RowId %3 and Sequence No. %4.
  DBERR_NUTLOGRESDETNOTEXIST     CONSTANT NUMBER := 463; --Nutritional Log Result Detail does not exists for Log Id %1, ColId %2 and Sequence No. %3.
  DBERR_NUTLYNOTFOUND            CONSTANT NUMBER := 189; --Nutritional Layout not found for ID (%1) and Revision (%2).
  DBERR_NUTPATHNOTFOUND          CONSTANT NUMBER := 142; --No Record found for Nutritional Calculation in ITNUTPATH for ID %1.
  DBERR_NUTPATHNOTFOUND2         CONSTANT NUMBER := 223; --No Data found in ITNUTPATH for ID %1, MOP Sequence %2 and Sequence %3.
  DBERR_NUTREFSPECALREADYEXIST   CONSTANT NUMBER := 136; --Nutritional Ref Specification for ID %1 already exist.
  DBERR_NUTREFSPECNOTFOUND       CONSTANT NUMBER := 135; --Nutritional Ref Specification for ID (%1) not found.
  DBERR_NUTRESULTNOTFOUND        CONSTANT NUMBER := 143; --Nutritional Result not found for ID %1 MopSequence %2 and Sequence %3.
  DBERR_NUTRIENTCONDNOTSATISFIED CONSTANT NUMBER := 456; --Nutrient condition not satisfied.
  DBERR_NUTRIENTNOTFOUND         CONSTANT NUMBER := 450; --Nutritional value not found for LogId <%1>, GroupId <%2>, ValueType <%3>, Property <%4>, Attribute <%5>.
  DBERR_OBJECTALREADYUSED        CONSTANT NUMBER := 244; --Object %1, revision %2, owner %3 is already used.
  DBERR_OBJECTINDEVSTATUS        CONSTANT NUMBER := 246; --A revision of this Object with status In Development already exists.
  DBERR_OBJECTNOTEXIST           CONSTANT NUMBER := 247; --Object or image %1, owner %2 does not exist
  DBERR_OBJECTNOTFOUND           CONSTANT NUMBER := 337; --Object not found.
  DBERR_OBJECTNOTINDEVSTATUS     CONSTANT NUMBER := 243; --Object %1, revision %2, owner %3 is not IN DEV status
  DBERR_OBJECTREFASPHANTOM       CONSTANT NUMBER := 245; --Object %1, revision %2, owner %3 is referenced as phantom.
  DBERR_OBJTCITEMEXIST           CONSTANT NUMBER := 476; --Object %1, revision %2, owner %3  is already associated with a TC Item.
  DBERR_OBJTCITEMNOTFOUND        CONSTANT NUMBER := 475; --Object %1, revision %2, owner %3  is not associated with a TC Item.
  DBERR_OBSOLETEBOMITEM          CONSTANT NUMBER := 234; --Obsolete Part(%1) found in item(s).
  DBERR_OBSOLETEPARTFORSPEC      CONSTANT NUMBER := 342; --Obsolete PART for specification %1 revision %2.
  --AP00996091 Start
  --orig
  --DBERR_OBSPARTITEMSFORSPEC      CONSTANT NUMBER          := 344;             --Obsolete PART items in bom for specification %1 revision %2.
  DBERR_OBSPARTITEMSFORSPEC CONSTANT NUMBER := 344; --Obsolete PART item in bom for specification %1 revision %2: %3.
  --orig
  --DBERR_OBSPARTPLANTFORSPEC      CONSTANT NUMBER          := 343;             --Obsolete PART/PLANT for specification %1 revision %2.
  DBERR_OBSPARTPLANTFORSPEC CONSTANT NUMBER := 343; --Obsolete PART/PLANT for specification %1 revision %2 plant %3.
  --orig
  --DBERR_OBSPARTPLANTITEMSFORSPEC CONSTANT NUMBER          := 345;             --Obsolete PART/PLANT items for specification %1 revision %2.
  DBERR_OBSPARTPLANTITEMSFORSPEC CONSTANT NUMBER := 345; --Obsolete PART/PLANT item for specification %1 revision %2 plant %3: %4.
  --AP00996091 End
  DBERR_OK_NO_ALM                CONSTANT NUMBER := 1100; --You have an old version of your SIMATIC IT Interspec license. Please contact your Siemens partner to acquire a new license.
  DBERR_ORAFAIL                  CONSTANT NUMBER := 27; --Error %1
  DBERR_PARENTINGREDIENTNOTEXIST CONSTANT NUMBER := 350; --Parent ingredient %1 does not exist.
  DBERR_PARTALREADYEXIST         CONSTANT NUMBER := 82; --Part <%1> already exist.
  DBERR_PARTDESCRIPTORNOTVALID   CONSTANT NUMBER := 274; --Part no %1 -> Descriptor <%2>  is not a valid descriptor for tree <%3>
  DBERR_PARTERROR                CONSTANT NUMBER := 266; --%1 PartNo -> %2 Field ID <%3>.
  DBERR_PARTINCORRECTCHAR        CONSTANT NUMBER := 12; --Invalid Character in Part Number
  DBERR_PARTINCORRECTCHARS       CONSTANT NUMBER := 14; --Invalid Characters in Part Number
  DBERR_PARTINERPCODERANGE       CONSTANT NUMBER := 55; --Part Number is in ERP Code Range.
  DBERR_PARTININTERNALCODERANGE  CONSTANT NUMBER := 28; --Part Number is in Internal Code Range.
  DBERR_PARTINTEGRITYVIOLATION   CONSTANT NUMBER := 289; --Integrity violation on %1 of table %2.
  DBERR_PARTINVALIDCHAR          CONSTANT NUMBER := 13; --Invalid Character(s) in Part Number
  DBERR_PARTKEYWORDNOTFOUND      CONSTANT NUMBER := 76; --Part keyword relation for partno  <%1>, keywordid <%2> and value <%3> does not exist.
  DBERR_PARTLOCALNOTALLOWED      CONSTANT NUMBER := 15; --Local Part is not allowed.
  DBERR_PARTMFCNOTFOUND          CONSTANT NUMBER := 64; --Part keyword relation for partno  <%1>, manufacturerid <%2> and value <%3> does not exist.
  DBERR_PARTNOINFOFORTREETYPE    CONSTANT NUMBER := 268; --Part no %1 -> No information found for tree type %2
  DBERR_PARTNOMAINCLASSFOUND     CONSTANT NUMBER := 275; --Part no %1 -> no main classification data found
  DBERR_PARTNOTAPPROVED          CONSTANT NUMBER := 285; --%1 PartNo -> %2 Revision <%3>.
  DBERR_PARTNOTCORRECTLYCLASS    CONSTANT NUMBER := 323; --Part %1 is not correctly classified.
  DBERR_PARTNOTCREATEDCONV       CONSTANT NUMBER := 262; --Part no %1 is not created -> Convert Error: field (%2) %3
  DBERR_PARTNOTCREATEDGEN        CONSTANT NUMBER := 264; --Part no %1 is not created -> General Error: field(%2) %3
  DBERR_PARTNOTCREATEDMASK       CONSTANT NUMBER := 260; --Part no %1 - %2 is not created -> mask <%3> is not valid for frame <%4>
  DBERR_PARTNOTCREATEDRET        CONSTANT NUMBER := 261; --Part no %1 is not created -> %2
  DBERR_PARTNOTFOUND             CONSTANT NUMBER := 34; --Part %1 is not found.
  DBERR_PARTNOTIMPORTEDPREVLEVEL CONSTANT NUMBER := 271; --Part no %1 -> Level <%2>  not imported while previous level does not exist
  DBERR_PARTNOTINSERTEDGEN       CONSTANT NUMBER := 265; --Part no %1 is not inserted -> General Error: %2
  DBERR_PARTNOTINSERTEDISNA      CONSTANT NUMBER := 263; --Part no %1 not inserted as %2 is N/A
  DBERR_PARTNOTNUMERIC           CONSTANT NUMBER := 11; --Part Number is not Numeric.
  DBERR_PARTNOTUPDATEDISNA       CONSTANT NUMBER := 267; --Part no %1 not updated as %2 is N/A
  DBERR_PARTOBSOLETE             CONSTANT NUMBER := 5; --The part %1 is set to obsolete.
  DBERR_PARTPLANTINBOM           CONSTANT NUMBER := 208; --Part-Plant (%1-%2) is still used somewhere as a bom item.
  DBERR_PARTPLANTNOTFOUND        CONSTANT NUMBER := 73; --Part plant relation for partno  <%1> and plantno <%2> does not exists.
  DBERR_PARTPLANTUSEDINBOM       CONSTANT NUMBER := 412; --Plant %1 cannot be deleted from the Part %2 as it is used in a Bill of Material.
  DBERR_PARTPRICENOTFOUND        CONSTANT NUMBER := 65; --Price for partno <%1>, period <%2>,  pricetype <%3> and plantno <%4> does not exist
  DBERR_PARTREVNOTFOUND          CONSTANT NUMBER := 171; --Part %1 , Revision %2 is not found.
  DBERR_PARTSAMEPARENT           CONSTANT NUMBER := 3; --The bom item can not be the same as the parent.
  DBERR_PARTSTATUSHISTNOTFOUND   CONSTANT NUMBER := 286; --Status History not found for Part No <%1> Revision <%2> Status <%3>.
  DBERR_PARTSTATUSTNOTFOUND      CONSTANT NUMBER := 287; --Status not found for Part No <%1> Revision <%2> Status Type <%3>.
  DBERR_PARTSTATUSTOOMANY        CONSTANT NUMBER := 288; --Too many Statuses found for Part No <%1> Revision <%2> Status Type <%3>.
  DBERR_PARTTREENOTMATCH         CONSTANT NUMBER := 272; --Part no %1 -> Tree type <%2>  must match with specification type <%3>
  DBERR_PARTTREEVIEWEXIST        CONSTANT NUMBER := 273; --Part no %1 -> Treeview <%2>  already exists. Unable to update.
  DBERR_PARTTYPEISNULL           CONSTANT NUMBER := 467; --Part type is null.
  DBERR_PARTUSEDINSPEC           CONSTANT NUMBER := 207; --Part %1 used in specifications.
  DBERR_PARTVALUEDESCRNOTVALID   CONSTANT NUMBER := 276; --Part no %1 -> Not a valid value <%2> for descriptor <%3>  for tree <%4>
  DBERR_PARTVALUENOTVALIDONLEVEL CONSTANT NUMBER := 270; --Part no %1 -> Value <%2>  is not a valid value on level %3
  DBERR_PARTWFNONEXTSTATUS       CONSTANT NUMBER := 405; --No next status found for specification %1 [%2] work flow group %3 work flow type %4 status type %5.
  DBERR_PARTWFTOOMANUSTATUS      CONSTANT NUMBER := 406; --Too many states found for specification %1 [%2]  work flow group %3 work flow type %4 status type %5.
  DBERR_PDINGINCORRECTQUANTITY   CONSTANT NUMBER := 215; --he following ingredients have an incorrect quantity: %1
  DBERR_PDINGNOLONGERUSED        CONSTANT NUMBER := 216; --The following ingredients can no longer be used: %1
  DBERR_PDINGNOTUSED             CONSTANT NUMBER := 217; --Ingredient %1 is not used.
  DBERR_PDVALID                  CONSTANT NUMBER := 218; --The Process Data is valid.
  DBERR_PEDDATEOUTOFRANGE        CONSTANT NUMBER := 155; --Phase in tolerance caused planned effective date to be out of range.
  DBERR_PEDLOWERTHANPEDLOWERREV  CONSTANT NUMBER := 420; --Plant Effective Date must be greater than Plant Effective Date of lower revision.
  DBERR_PLANTALREADYINPLANTGROUP CONSTANT NUMBER := 94; --Plant <%1> already exist in the PlantGroup <%2>
  DBERR_PLANTGROUPALREADYEXIST   CONSTANT NUMBER := 93; --PlantGroup <%1> already exist.
  DBERR_PLANTGROUPNOTFOUND       CONSTANT NUMBER := 92; --Plantgroup %1 is not found.
  DBERR_PLANTGROUPUSED           CONSTANT NUMBER := 103; --Cannot remove plantgroup %1 as it is still used.
  DBERR_PLANTINPLANTGRPNOTFOUND  CONSTANT NUMBER := 132; --Plant %1 not found in Plant group %2
  DBERR_PLANTNOTASSIGNEDTOPART   CONSTANT NUMBER := 363; --Plant <%1> not assigned to part <%2>.
  DBERR_PLANTNOTFOUND            CONSTANT NUMBER := 47; --Plant %1 is not found.
  DBERR_PLANTNOTINPLANTGROUP     CONSTANT NUMBER := 95; --Plant <%1> does not exist in the PlantGroup <%2>
  DBERR_PLANTSNOTAVAILABLE       CONSTANT NUMBER := 403; --The following plants will not be available : %1.
  DBERR_PLANTUSED                CONSTANT NUMBER := 117; --Cannot remove plant %1 as it is still used.
  DBERR_PREFIXDOESNOTEXIST       CONSTANT NUMBER := 441; --Prefix does not exist.
  DBERR_PREFIXINVALID            CONSTANT NUMBER := 356; --%1 - %2 is not a valid prefix.
  DBERR_PREFIXISMANDATORY        CONSTANT NUMBER := 423; --The prefix is mandatory.
  DBERR_PREVREVISIONISNOTCURRENT CONSTANT NUMBER := 324; --You cannot make a revision current when a previous revision is still not current.
  DBERR_PROCESSDATANOTFOUND      CONSTANT NUMBER := 338; --No process data found.
  DBERR_PROPERTYDFEXIST          CONSTANT NUMBER := 211; --Property Display Format already exists with Layout ID %1 and Revision %2.
  DBERR_PROPERTYDFNOTFOUND       CONSTANT NUMBER := 212; --Property Display Format not found for Layout ID %1 and Revision %2.
  DBERR_PROPERTYGROUPNOTFILLED   CONSTANT NUMBER := 332; --Property Group not filled.
  DBERR_PROPERTYGRPNOTEXTENDABLE CONSTANT NUMBER := 67; --Property group %5 of specification section %1-%2-%3-%4 is not extendable
  DBERR_PROPERTYIDNOTFNDFORDESC  CONSTANT NUMBER := 414; --Property Id not found for description %1.
  DBERR_PROPERTYNOTCONFIGURED    CONSTANT NUMBER := 465; --The property <%1>. is not configured in table <%2> for reference spec <%3>.
  DBERR_PROPERTYNOTFOUND         CONSTANT NUMBER := 137; --Property (%1,%2) not found.
  DBERR_PROPGROUPIDNOTFNDFORDESC CONSTANT NUMBER := 415; --Property Group Id not found for description %1.
  DBERR_PWDEQUALTOUSER           CONSTANT NUMBER := 300; --Password and username cannot be the same.
  DBERR_PWDFIRSTCHARISNUM        CONSTANT NUMBER := 346; --Password must start with character.
  DBERR_PWDNOTREUSABLE           CONSTANT NUMBER := 297; --Password cannot be reused yet.
  DBERR_PWDTOOSHORT              CONSTANT NUMBER := 299; --Password length less than 6.
  DBERR_QUEUENOTRUNNING          CONSTANT NUMBER := 396; --The Multi Operation database process is not running.Please contact your database administrator.
  DBERR_REASONFORISSUEMANDATORY  CONSTANT NUMBER := 325; --The reason for issue is mandatory.
  --AP00882254 --AP00882879
  DBERR_REASONFORSTCHMANDATORY CONSTANT NUMBER := 491; --The reason for status chnage is mandatory (In interspc6.3HF14 the error code was 471).
  DBERR_REFERENCETEXTNOTFOUND  CONSTANT NUMBER := 333; --Reference Text not found.
  DBERR_REFTEXTALREADYUSED     CONSTANT NUMBER := 291; --Reference Text %1, revision %2, owner %3 is already used.
  DBERR_REFTEXTASPHANTOM       CONSTANT NUMBER := 290; --Reference Text %1, revision %2, owner %3 is referenced as phantom.
  DBERR_REFTEXTIDNOTFNDFORDESC CONSTANT NUMBER := 416; --Reference text Id not found for description %1.
  DBERR_REFTEXTINDEVSTATUS     CONSTANT NUMBER := 466; --A revision of this Reference Text with status In Development already exists.
  DBERR_REFTEXTNOTINDEVSTATUS  CONSTANT NUMBER := 292; --Reference Text %1, revision %2, owner %3 is not IN DEV status
  DBERR_ROUNDFUNCTIONNOTFOUND  CONSTANT NUMBER := 200; --Function <%1> used for Nutritional Rounding is not found in Database. Please check itnutrounding Table.
  DBERR_RULESETNAMEFOUND       CONSTANT NUMBER := 126; --Rule Set Name <%1> already exist for Rule ID  %2.
  DBERR_RULESETNOTFOUND        CONSTANT NUMBER := 125; --Rule Set not found for Rule ID %1.
  DBERR_RULETYPENOTFOUND       CONSTANT NUMBER := 127; --Rule type %1 not found.
  DBERR_SAVEAFTERMOD           CONSTANT NUMBER := 45; --This specification %1 [%2]  section %3 has been changed after you had opened it. Save not allowed! Please refresh.
  --AP01079385
  DBERR_SAVEAFTERMOD2            CONSTANT NUMBER := 495; --This specification %1 [%2]  section %3 has been changed after you had opened it. Save not allowed! Please re-open the SECTION.DESCRIPTION
  DBERR_SCHEMANAMENOTFOUND       CONSTANT NUMBER := 308; --Schemaname not found.
  DBERR_SECTIONALREADYLOCKED     CONSTANT NUMBER := 445; --Specification %1 [%2] , Section %3 locked by user [%4].
  DBERR_SECTIONIDNOTFNDFORDESC   CONSTANT NUMBER := 417; --Section Id not found for description %1.
  DBERR_SECTIONNOTLOCKED         CONSTANT NUMBER := 447; --Specification %1 [%2] , Section %3 not locked.
  DBERR_SHORTDESCREMPTY          CONSTANT NUMBER := 248; --Short description is empty
  DBERR_SHORTDESCRNOTUNIQUE      CONSTANT NUMBER := 249; --Short description is not unique
  DBERR_SINGLEPROPNOTFILLEDIN    CONSTANT NUMBER := 335; --Single Property not filled in.
  DBERR_SOMECOMPWITHOUTSPECAPP   CONSTANT NUMBER := 322; --Some components in the bom do NOT have a Specification which is APPROVED or CURRENT.
  DBERR_SPBASEIDNOTFOUND         CONSTANT NUMBER := 141; --Base name %1 not found for %2 [%3]
  DBERR_SPECALREADYEXIST         CONSTANT NUMBER := 352; --Specification %1 [%2] already exists.
  DBERR_SPECALREADYLOCKED        CONSTANT NUMBER := 444; --Specification %1 [%2]  locked by user [%3].
  DBERR_SPECIFICATIONNOTFOUND    CONSTANT NUMBER := 36; --Specification %1 [%2] is not found
  DBERR_SPECIFICATIONNOTINDEV    CONSTANT NUMBER := 348; --Data for %1 - %2 - not imported as specification not in development.
  DBERR_SPECIFICATIONUNLOCKABLE  CONSTANT NUMBER := 470; --Lock: The configuration does not allow to lock the specifications.
  DBERR_SPECINPEDGROUP           CONSTANT NUMBER := 304; --Specification %1 [%2] is in a PED group.
  DBERR_SPECINTLPREFIX           CONSTANT NUMBER := 357; --Not allowed to create a local specification with an international prefix (Part No:  %1 ).
  DBERR_SPECMUSTBEINTL           CONSTANT NUMBER := 302; --Specification <%1>  revision <%2> must be International
  DBERR_SPECNOTINDEV             CONSTANT NUMBER := 388; --Specification %1 [%2] is not in development
  DBERR_SPECNOTLOCKED            CONSTANT NUMBER := 446; --Specification %1 [%2]  not locked.
  DBERR_SPECNOTMULTILANG         CONSTANT NUMBER := 52; --Specification %1 [%2] is not multi-language.
  DBERR_SPECSERVERNOTRUNNING     CONSTANT NUMBER := 409; --Specdata server is not running.
  DBERR_SPECSNOTPROCESSED        CONSTANT NUMBER := 312; --[%1] specification(s) have not been processed.
  DBERR_SPECSTATUSCURRENT        CONSTANT NUMBER := 395; --Part No %1 Revision [%2] Status [%3] <> current status [%3].
  DBERR_SPECSTATUSINVALID        CONSTANT NUMBER := 279; --Specification status is invalid
  DBERR_SPECSTATUSNOTFOUND       CONSTANT NUMBER := 278; --Specification : Part No %1 Revision [%2] Status [3] is not found
  DBERR_SPECTCITEMEXIST          CONSTANT NUMBER := 474; --Specification %1 [%2]  is already associated with a TC Item.
  DBERR_SPECTCITEMNOTFOUND       CONSTANT NUMBER := 473; --Specification %1 [%2]  is not associated with a TC Item.
  DBERR_SPECTYPEISHISTORIC       CONSTANT NUMBER := 435; --The specification type is historic.
  DBERR_SPECTYPEISMANDATORY      CONSTANT NUMBER := 425; --The specification type is mandatory.
  DBERR_SPECTYPEISNOTINTL        CONSTANT NUMBER := 434; --The specification type is not international.
  DBERR_SPECTYPENOTEXIST         CONSTANT NUMBER := 353; --Specification Type %1 does not exist.
  DBERR_SPITEMNOTFOUND           CONSTANT NUMBER := 41; --Item not found in specification %1 [%2] section %3-%4-%5
  DBERR_SPNOBOMFORUSEPART        CONSTANT NUMBER := 214; --Part %1 does not have BOM for plant %2.
  DBERR_SPPDLINEEXITS            CONSTANT NUMBER := 104; --Process Data Line Exists for Specification %1[%2] plant %3 line %4 configuration %5 process line revision %6
  DBERR_SPPDLINENOTFOUND         CONSTANT NUMBER := 107; --Process data process line not found for specification %1 [%2] plant %3 line %4 configuration %5 process line revision %6
  DBERR_SPPDRECIRULATETO         CONSTANT NUMBER := 110; --RecirculateTo number %1 must be one of the stage sequence numbers.
  DBERR_SPPDSTAGEDATANOTFOUND    CONSTANT NUMBER := 123; --Stage data not found for specification %1 [%2], plant %3, line %4, configuration %5, stage %6.
  DBERR_SPPDSTAGENOTFOUND        CONSTANT NUMBER := 122; --Stage %1 not found for specification %2 [%3], plant %4, line %5, configuration %6.
  DBERR_SPPDSTAGETEXTNOTFOUND    CONSTANT NUMBER := 124; --Stage text not found for specification %1 [%2], plant %3, line %4, configuration %5, stage %6.
  DBERR_SPPROPERTYALREADYINGROUP CONSTANT NUMBER := 57; --Property/attribute <%6/%7> is already in property group <%5> in specification section <%1-%2-%3-%4>
  DBERR_SPPROPERTYNOTALLOWED     CONSTANT NUMBER := 60; --The frame or mask does not allow the property/attribute <%6/%7> in property group <%5> in specification section <%1-%2-%3-%4>.
  DBERR_SPPROPERTYNOTFOUND       CONSTANT NUMBER := 56; --Property/attribute <%6/%7> not found in property group <%5> in specification section <%1-%2-%3-%4>
  DBERR_SPSECTIONNOTEXTENDABLE   CONSTANT NUMBER := 66; --Specification section %1-%2-%3-%4 is not extendable
  DBERR_SPSECTIONNOTFOUND        CONSTANT NUMBER := 35; --Specification section %1 [%2] %3-%4 is not found
  DBERR_STAGEDATAFOUND           CONSTANT NUMBER := 378; --Stage data found for specification %1 [%2], plant %3, line %4, configuration %5.
  DBERR_STAGENOTFOUND            CONSTANT NUMBER := 109; --Stage %1 Not Found
  DBERR_STATUSTYPEDOESNOTEXIST   CONSTANT NUMBER := 471; --Status type %1 does not exist.
  DBERR_STDLANGNOTALLOWED        CONSTANT NUMBER := 206; --The standard language (LanguageId = 1) cannot be used as an alternative language
  DBERR_SUBSECTIDNOTFNDFORDESC   CONSTANT NUMBER := 418; --SubSection Id not found for description %1.
  DBERR_SUCCESS                  CONSTANT NUMBER := 0; --Normal, successful completion.
  DBERR_SYNONYMNOTEXIST          CONSTANT NUMBER := 351; --Synonym %1 does not exist.
  DBERR_TESTMETHODNOTFOUND       CONSTANT NUMBER := 111; --Test method <%1> is not found.
  DBERR_TESTMETHODTYPENOTFOUND   CONSTANT NUMBER := 411; --Test method type <%1> is not found.
  DBERR_TMNOTASSIGNEDTOPROP      CONSTANT NUMBER := 305; --Test method <%1> not assigned to property <%2>.
  --AP00975410
  DBERR_TMASSIGNEDTOPROPINUSAGE CONSTANT NUMBER := 489; --Test method <%1> assigned to property <%2> is in usage so association cannot be deleted.
  --AP01272655
  DBERR_TMOBSOLETED              CONSTANT NUMBER := 497; --A referenced Test Method is obsoleted. Please look to the error log for more details.
  DBERR_TOOMANYROWSTREETYPE      CONSTANT NUMBER := 269; --Too many rows - %1 %2
  DBERR_TOOMANYUSERS             CONSTANT NUMBER := 1104; --Licensed number of users already reached. Please contact your Siemens partner to extend your SIMATIC IT Interspec license.
  DBERR_UNABLETOOPENFILE         CONSTANT NUMBER := 257; --Unable to open file <%1> Error <%2>
  DBERR_UOMALREADYASSIGNED       CONSTANT NUMBER := 482; --Uom <%1> already assigned at group <%2>.
  DBERR_UOMALREADYEXIST          CONSTANT NUMBER := 478; --The UOM <%1> already exist.
  DBERR_UOMGROUPALREADYEXIST     CONSTANT NUMBER := 477; --The UOM Group <%1> already exist.
  DBERR_UOMGROUPNOTFOUND         CONSTANT NUMBER := 481; --Uom Group <%1> not found.
  DBERR_UOMHISTORIC              CONSTANT NUMBER := 440; --Uom <%1> is historic.
  DBERR_UOMISMANDATORY           CONSTANT NUMBER := 429; --The uom is mandatory.
  DBERR_UOMMISMATCH              CONSTANT NUMBER := 194; --Cannot convert all Quantities to Dominant UOM <%1>.
  DBERR_UOMMISMATCH2             CONSTANT NUMBER := 227; --Uom <%1> or Conv.Uom<%2> for Part %3[%4] can not be converted to Dominant Uom<%5>.
  DBERR_UOMNOTFOUND              CONSTANT NUMBER := 479; --Uom <%1> not found.
  DBERR_UOMPARTBASENOTDEVSPEC    CONSTANT NUMBER := 303; --UOM can not be changed of a part that is the basis of a non in dev specification
  DBERR_USER21CFR11UNDELETABLE   CONSTANT NUMBER := 238; --User %1 is 21CFR11 and is undeletable
  DBERR_USERALREADYEXIST         CONSTANT NUMBER := 236; --User %1 already exist.
  DBERR_USERCURRENTUNDELETABLE   CONSTANT NUMBER := 296; --Current user is undeletable.
  DBERR_USERINUSERGROUPS         CONSTANT NUMBER := 298; --User  [%1]  is still present in Usergroups.
  DBERR_USERNAMEINVALID          CONSTANT NUMBER := 295; --Username [%1] is not valid.
  DBERR_USERNAMEISUNICODE        CONSTANT NUMBER := 240; --User name cannot be Unicode.
  DBERR_USERNOTACTIVE            CONSTANT NUMBER := 254; --User %1 is not active.
  DBERR_USERNOTALLOWEDMODPWD     CONSTANT NUMBER := 253; --User not allowed to modify password
  DBERR_USERNOTFOUND             CONSTANT NUMBER := 237; --User %1 does not exist.
  DBERR_USERNOTFOUNDINUSERGROUP  CONSTANT NUMBER := 284; --User [%1] not found in User Group.
  DBERR_USERNOTOWNERINTLFRAME    CONSTANT NUMBER := 381; --User is not the Owner of the International Frame.
  DBERR_USERPREFNOTFOUND         CONSTANT NUMBER := 313; --User preference : user <%1> section <%2> preference <%3> is not found
  DBERR_VALUEFIELDEQNA           CONSTANT NUMBER := 256; --Value of field %1 is equal to #N/A
  DBERR_WORKFLOWGROUPINVALID     CONSTANT NUMBER := 281; --Specification : Workflow Group [%1] is invalid
  DBERR_WORKFLOWGROUPISMANDATORY CONSTANT NUMBER := 427; --The Workflow group  is mandatory.
  DBERR_WORKFLOWGROUPNOTEXIST    CONSTANT NUMBER := 355; --Workflow group %1 does not exist.
  DBERR_WORKFLOWGROUPNOTFOUND    CONSTANT NUMBER := 280; --Specification : Workflow Group [%1] not found
  DBERR_WORKFLOWIDINVALID        CONSTANT NUMBER := 283; --Specification : Workflow ID [%1] is invalid
  DBERR_WORKFLOWIDNOTFOUND       CONSTANT NUMBER := 282; --Specification : Workflow ID [%1] does not exist for status [%2]
  DBERR_WORKFLOWTYPENOTEXIST     CONSTANT NUMBER := 404; --Workflow type %1 does not exist.
  DBERR_WRONGAPPROVERSELECTION   CONSTANT NUMBER := 469; --ChangeStatus: Wrong Approvers Selection.
  -- ISQF-235 start
  DBERR_PROPERTYGROUPNOTFILLEDT CONSTANT NUMBER := 9332; --Property Group not filled return table.  -- haju
  DBERR_REFERENCETEXTNOTFOUNDT  CONSTANT NUMBER := 9333; --Reference Text not found return table.
  DBERR_SINGLEPROPNOTFILLEDINT  CONSTANT NUMBER := 9335; --Single Property not filled in  return table.
  DBERR_FREETEXTNOTFILLEDINT    CONSTANT NUMBER := 9336; --Free text not filled in return table.
  DBERR_OBJECTNOTFOUNDT         CONSTANT NUMBER := 9337; --Object not found return table.
  DBERR_ATTACHEDSPECNOTFOUNDT   CONSTANT NUMBER := 9339; --No attached specification found return table.
  -- ISQF-235 end
  -- TFS 4723 start
  DBERR_NOTEDITALLOWED CONSTANT NUMBER := 9340; --No edit_allowed property_layout.
  -- TFS 4723 end
  --TFS 4214 start
  DBERR_INVALIDPEDDATE CONSTANT NUMBER := 9341; -- The date is invalid (PED) – it must be less than a 100 years in the future
--TFS 4214 end
END iapiConstantDbError;
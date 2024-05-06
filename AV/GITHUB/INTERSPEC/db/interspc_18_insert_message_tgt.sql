--ERROR-MESSAGES WORDEN OPGESLAGEN IN ITMESSAGE-TABEL:
/*
Name        Null?    Type               
----------- -------- ------------------ 
MSG_ID      NOT NULL VARCHAR2(30 CHAR)  
CULTURE_ID  NOT NULL VARCHAR2(2 CHAR)   
DESCRIPTION NOT NULL VARCHAR2(60 CHAR)  
MESSAGE     NOT NULL VARCHAR2(500 CHAR) 
MSG_LEVEL   NOT NULL NUMBER(1)          
MSG_COMMENT          VARCHAR2(255 CHAR) 
*/

SELECT msg_id, description, MESSAGE
FROM  ITMESSAGE
WHERE MSG_ID like '%209%'
AND CULTURE_ID = ( SELECT VALUE
                   FROM ITUSPREF
                   WHERE USER_ID = 'PSC'
                   AND SECTION_NAME = 'General'
                   AND PREF = 'ApplicationLanguage' 
                   );

-- "-20929" "PartNo is part of Threadless GreenTyre"

SELECT msg_id, culture_id, description, message, msg_level, msg_comment FROM ITMESSAGE WHERE MSG_ID like '%209%' order by 3,2;
/*
-20904	From Part/Rev filled					Both FROM_PART and FROM_REVISION must contain valid values
-20905	Status Change							Property Group has no value
-20906	Status Change							Reference Text not found
-20907	Status Change							BoM not found
-20908	Status Change							Single Property has no value
-20909	Status Change							Free Text has no value
-20910	Status Change							No objects found
-20911	Status Change							No process data found
-20912	Status Change							No attached specs found
-20913	Status Change							No ingredient component list found
-20914	Obsolete part							The part has a bom but is marked as obsolete. Unable to change status.
-20915	Obsolete part plant						The part has a bom but the part/plant is marked as obsolete. Unable to change status.
-20916	Obsolete component						The bom contains an item that is marked as obsolete. Unable to change status.
-20917	Obsolete component plant				The bom contains an item for which part/plant is marked as obsolete. Unable to change status.
-20901	Frame copy Dev. status					A Frame already exists in the development cycle with a status type of DEVELOPMENT. Two Frames cannot exist in development. 
-20902	Frame copy local int check				As an international user you can not copy a local frame
-20903	Frame copy owner int check				As an international user you can not copy an international frame you do not own
209		DBERR_BOMDFEXIST						BOM Display Format already exists with Layout ID %1 and Revision %2.
-20922	Missing property value					Specification is missing required Commercial article code.
-20923	Attached Spec Revision Mandatory		Attached Specifications require a revision. Phantom is not allowed.
-20924	Based Upon Spec not in Attached Specs	Based Upon Spec is not in Attached Specifications.
-20925	Invalid Plant in Spec					A plant was found in the specification header that does not match the part number prefix. Please delete any incorrect plants and try again.
-20926	Invalid Plant in BoM					A plant was found in the BoM header that does not match the part number prefix. Please delete any incorrect plants and try again.
-20927	Label values changed					Label values have changed after being submitted to EPREL. Please change the SAP article code before submitting the specification.
-20928	Duplicate property value				Commercial article code has a value that is already used.
-20918	Base Name Required						Base name not found
-20919	MFC Plant Descr							Description is already used.  Please change the description
-20920	MFC Type Descr							Description is already used.  Please change the description
-20921	ING Note Descr							Description is already used.  Please change the description
-20929	Treadless Greentyre						PartNo is part of Treadless GreenTyre, check all tyres based on same Greentyre!
*/

prompt 
prompt inserten nieuwe message:
prompt

--update itmessage 
--set description = 'Treadless Greentyre'
--, message='PartNo is part of Treadless GreenTyre, check all tyres based on same Greentyre!' 
--where msg_id='-20929';


INSERT INTO ITMESSAGE VALUES ('-20929', 'en','Treadless Greentyre', 'PartNo is part of Treadless GreenTyre, check all tyres based on same Greentyre!',1,null);
commit;


prompt
prompt einde script
prompt





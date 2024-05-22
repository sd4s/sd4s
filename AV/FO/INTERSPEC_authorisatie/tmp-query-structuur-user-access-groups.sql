SELECT A.ACCESS_GROUP
,      A.DESCRIPTION
FROM ACCESS_GROUP A 
WHERE NOT EXISTS (SELECT UAG.ACCESS_GROUP FROM USER_ACCESS_GROUP UAG WHERE UAG.ACCESS_GROUP = A.ACCESS_GROUP)
;
/*
--1925	ObjRefText Default Access Group for 3Tier Export
*/

SELECT U.USER_GROUP_ID
,      U.DESCRIPTION
FROM USER_GROUP U
WHERE NOT EXISTS (SELECT UAG.USER_GROUP_ID FROM USER_ACCESS_GROUP UAG WHERE UAG.USER_GROUP_ID = U.USER_GROUP_ID)
;
/*
196	Quality Environmental Assurance
1236	Lead Engineers  Apollo R&D PCR
1276	Approval of DEV specs
1036	Global raw materials CV
209	Proces Technology Reinforcement
536	All users except configurators
1398	Apollo approval CMPD R&D CV
1017	Process Engineer Industrialisation
359	Process technology Tyre Building
-1	<Originator>
756	F&A Apollo Vredestein
696	Approval Current Extruders
1397	Apollo approval CMPD R&D PCR
676	Extrusion mail Enschede
1537	Laboratory plant GYO
636	Approval TCE Mail
1279	Process Technology Enschede SFG (beads, cutting, IL)
1318	Approval of  GYO specs TBR
1477	reinforcements RnD EA
1280	A_RM_Approval Enschede
1216	Approval of GYO specs
1457	Apollo Approval calender specs R&D PCR
362	Process technology APBM
1538	Laboratory plant ENS
656	Limda reinforcement materials
1319	Approval of GYO specs PCR
376	Purchasing department
1378	Approval of compounds Gyo
596	All users South Africa
216	Read Only
1517	Approval of CHE specs
856	Design & Development Global R&D PCR
*/


--er zijn users die een vreemde structuur hebben


SELECT * FROM FRAMES_HEADER WHERE ACCESS_GROUP = 1688;



SELECT UAG.UPDATE_ALLOWED			 
FROM USER_ACCESS_GROUP UAG
WHERE UAG.ACCESS_GROUP = P_AG
AND   UAG.USER_GROUP_ID = P_UG
;


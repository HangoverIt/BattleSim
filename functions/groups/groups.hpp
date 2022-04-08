#define BATTLEGROUPS "BattleGroups"
#define BATTLEGRPVAR (missionNamespace getVariable BATTLEGROUPS)
#define CREATEBATTLEGRP missionNamespace setVariable [BATTLEGROUPS, createHashMap]

#define getGroupID(grp) (grp select 0)
#define getGroupNode(grp) (grp select 1)
#define getGroupMission(grp) (grp select 2)
#define getGroupState(grp) (grp select 3)
#define getGroupInfo(grp) (grp select 4)
#define getGroupObjects(grp) (grp select 5)
#define getGroupPosition(grp) (grp select 6)
#define getGroupSide(grp) (grp select 7)
#define setGroupMission(grp,mission) (grp set[2, mission]) 
#define setGroupPosition(grp,position) (grp set[6, position])
#define setGroupNode(grp,nodeid) (grp set[1, nodeid])

#define roadMoveComplete(ret) (ret select 0)
#define roadMoveSafe(ret) (ret select 1)
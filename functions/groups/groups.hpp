#define BATTLEGROUPS "BattleGroups"
#define BATTLEGRPVAR (missionNamespace getVariable BATTLEGROUPS)
#define CREATEBATTLEGRP missionNamespace setVariable [BATTLEGROUPS, createHashMap]

#define getGroupID(grp) (grp select 0)
#define getGroupNode(grp) (grp select 1)
#define getGroupMission(grp) (grp select 2)
#define getGroupState(grp) (grp select 3)
#define getGroupTemplate(grp) (grp select 4)
#define getGroupObjects(grp) (grp select 5)

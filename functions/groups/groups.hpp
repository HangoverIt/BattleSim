#define BATTLEGROUPS "BattleGroups"
#define BATTLEGRPVAR (missionNamespace getVariable BATTLEGROUPS)
#define CREATEBATTLEGRP (missionNamespace setVariable [BATTLEGROUPS, createHashMap] ;

#define getGroupID(grp) (grp select 0)
#define getGroupWaypoint(grp) (grp select 1)
#define getGroupState(grp) (grp select 2)
#define getGroupTemplate(grp) (grp select 3)
#define isSpawned(grp) (grp select 4)

#define BATTLEGROUPS "BattleGroups"
#define BATTLEGRPVAR (missionNamespace getVariable BATTLEGROUPS)
#define CREATEBATTLEGRP (missionNamespace setVariable [BATTLEGROUPS, createHashMap] ;

#define getGroupID(grp) (grp select 0)
#define getGroupTemplate(grp) (grp select 1)

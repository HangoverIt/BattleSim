#define SIMCONFIG "configuration"
#define SIMCONFIGVAR (missionNamespace getVariable SIMCONFIG)
#define CREATESIMCONFIG (missionNamespace setVariable [SIMCONFIG, createHashMap]) ;
#define SETSIMGRAPH(g) (missionNamespace setVariable [SIMCONFIG, g])

#define getConfigMissionMax(cmiss) (cmiss select 0)
#define getConfigMissionFind(cmiss) (cmiss select 1)
#define getConfigMissionRun(cmiss) (cmiss select 2)
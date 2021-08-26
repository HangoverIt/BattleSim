#define SIMGRAPH "locationGraph"
#define SIMGRAPHVAR (missionNamespace getVariable SIMGRAPH)
#define CREATESIMGRAPH (missionNamespace setVariable [SIMGRAPH, createHashMap]) ;
#define SETSIMGRAPH(g) (missionNamespace setVariable [SIMGRAPH, g])

#define getPathDistance(path) ((path) select 0)
#define getPathArray(path) ((path) select 1)
#define SIMGRAPH "locationGraph"
#define SIMGRAPHVAR (missionNamespace getVariable SIMGRAPH)
#define CREATESIMGRAPH (missionNamespace setVariable [SIMGRAPH, createHashMap]) ;
#define SETSIMGRAPH(g) (missionNamespace setVariable [SIMGRAPH, g])
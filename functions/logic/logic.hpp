#define SIDESTATS "GraphStats"
#define SIDESTATSVAR (missionNamespace getVariable SIDESTATS)
#define CREATESIDESTATS missionNamespace setVariable [SIDESTATS, createHashMap]

// Define all score modifiers here
#define SIM_NODE_CAPTURED 						2
#define SIM_NODE_CONNECTED 						1
#define SIM_NODE_ENEMY_CONNECTED				1
#define SIM_NODE_OWNED 							1
#define SIM_NODE_HOME_DEFENSE_STEPS 			4
#define SIM_NODE_HOME_DEFENSE_DISTANCE 			1000
#define SIM_NODE_HOME_DEFENSE					1
#define SIM_NODE_DEFENDER						1
#define SIM_NODE_AIRPORT_INFLUENCE_RANGE		1500
#define SIM_NODE_AIRPORT_INFLUENCE				10
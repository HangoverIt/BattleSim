#include "..\graph\graph.hpp"
private _locations = [] call Sim_fnc_allLocations ;
[_locations] call Sim_fnc_createGraph; // Create SIMGRAPHVAR

// Load predefined graph from file. Must have called Sim_fnc_createGraph prior to load
//[] call Sim_fnc_loadGraph ;

// Call this to create a new graph from all locations
private _markers = [SIMGRAPHVAR, _locations, false] call Sim_fnc_makeLocationGraph;

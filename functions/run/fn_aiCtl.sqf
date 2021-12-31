/*
	Author: HangoverIt

	Description:
		Central process to run ai checks and control

	Parameter(s):
		None
    
	Returns:
		bool
*/
#include "..\groups\groups.hpp"
#include "..\graph\graph.hpp"
#include "..\config\config.hpp"

private _graph = SIMGRAPHVAR ;
// One time setup of the side stats
// TO DO - load in side stats from previous save
[_graph] call Sim_fnc_createSideStats ;

// Set the start node and make it owned by the starting side
{
	_start = [_x] call Sim_fnc_getStartNode;
	(_graph get _start) set ["owner", _x] ;
} foreach ([] call Sim_fnc_getFactionSides);

// Create the side pools - TO DO: load from save state
private _pool = [] call Sim_fnc_initPool ;

while {true} do {
	
	// Create any required missions - extract units from the pool
	[] call Sim_fnc_createMission ;

	sleep 20 + (floor (random 10)) ;
};
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

private _graph = SIMGRAPHVAR ;
// One time setup of the side stats
// TO DO - load in side stats from previous save
[_graph] call Sim_fnc_createSideStats ;

// Set the start node and make it owned by the starting side
{
	_start = [_x] call Sim_fnc_getStartNode;
	(_graph get _start) set ["owner", _x] ;
} foreach ([] call Sim_fnc_getFactionSides);

while {true} do {
	{
		if ([_x] call Sim_fnc_redeployGroups) then {
			[_x, [], [_x] call Sim_fnc_getStartNode] call Sim_fnc_createGroup ; 
		};
	} foreach ([] call Sim_fnc_getFactionSides);

	_sides = [] call Sim_fnc_getAllGroups ;
	{
		_side = _x ;
		_groups = _y ;

		{
			_grpid = _x ;
			_grp = _y ;
			if(!([_grp] call Sim_fnc_hasMission)) then {
				[_grp, _graph, _side] call Sim_fnc_createMission;
			};
		}forEach _groups ;
	}forEach _sides ;

	sleep 20 + (floor (random 10)) ;
};
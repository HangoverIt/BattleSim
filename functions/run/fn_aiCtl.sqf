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

private _eastStart = "Kavala[3458.95,12966.4,-6.1822]";
private _westStart = "Pyrgos[16780.6,12604.5,-18.9913]";

(_graph get _eastStart) set ["owner", east] ;
(_graph get _westStart) set ["owner", west] ;

while {true} do {
	if ([west] call Sim_fnc_redeployGroups) then {
		[west, [], _westStart] call Sim_fnc_createGroup ; // TO DO - add config for start node for both sides
	};
	if ([east] call Sim_fnc_redeployGroups) then {
		[east, [], _eastStart] call Sim_fnc_createGroup ; // TO DO - add config for start node for both sides
	};

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
/*
	Author: HangoverIt

	Description:
		Get coordinates for a group

	Parameter(s):
		1. Group
    
	Returns:
		3D coordinates
*/
#include "..\groups\groups.hpp"
#include "..\graph\graph.hpp"
params["_group"];

private _pos = getGroupPosition(_group);

if ([_pos] call Sim_fnc_isNullPosition) then {
	private _graph = SIMGRAPHVAR ;
	private _node = getGroupNode(_group) ;
	_pos = (_graph get _node) get "position" ;
};

_pos;
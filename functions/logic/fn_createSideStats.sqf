/*
	Author: HangoverIt

	Description:
		Create the side stats. This should only be called once as it sets global vars.
		Side stats are updated through events and it shouldn't be necessary to run fn_graphStats again

	Parameter(s):
		1: Graph
		
	Returns:
		Hashmap of side stats
*/
#include "..\logic\logic.hpp"
params["_graph"];

if (isNil SIDESTATS) then {
  CREATESIDESTATS;
};
private _sidestats = SIDESTATSVAR;

// Create stats for all factions
{
	_start = [_x] call Sim_fnc_getStartNode;
	_sidestats set [_x, [_graph, _x, _start] call Sim_fnc_graphStats] ;
} foreach ([] call Sim_fnc_getFactionSides);

_sidestats ;
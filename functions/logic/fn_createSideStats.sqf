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

// Create stats for both sides
_sidestats set [west, [_graph, west] call Sim_fnc_graphStats] ;
_sidestats set [east, [_graph, east] call Sim_fnc_graphStats] ;

_sidestats ;
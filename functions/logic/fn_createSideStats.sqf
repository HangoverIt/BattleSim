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
_sidestats set [west, [_graph, west, "Pyrgos[16780.6,12604.5,-18.9913]"] call Sim_fnc_graphStats] ;
_sidestats set [east, [_graph, east, "Kavala[3458.95,12966.4,-6.1822]"] call Sim_fnc_graphStats] ;

_sidestats ;
/*
	Author: HangoverIt

	Description:
		Make the location graph. Optional creation with a location array

	Parameter(s):
		1 (Optional): Location array (Sim locations)

	Returns:
		BOOL
*/
#include "..\graph\graph.hpp"
params[["_locations", [], []]];

if (isNil SIMGRAPH) then {
  CREATESIMGRAPH;
};
private _locationGraph = SIMGRAPHVAR;

{
	[_locationGraph, _x] call Sim_fnc_createNode;
}forEach _locations;

true ;
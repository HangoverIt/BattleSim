/*
	Author: HangoverIt

	Description:
	Make the location graph. Optional creation with a location array

	Parameter(s):
		1 (Optional): Location array (Sim locations)

	Returns:
	HashMap
*/
params[["_locations", [], []]];

private _locationGraph = createHashMap ; // hash of [location _ref, list of [connected location ref, distance]]

{
	[_locationGraph, _x] call Sim_fnc_createNode;
}forEach _locations;

_locationGraph ;
/*
	Author: HangoverIt

	Description:
	Create a node in the location graph

	Parameter(s):
		1 (Mandatory): Location graph
		2 (Mandatory): Location (Sim location array)

	Returns:
		Hashmap of node
*/
#include "..\location\location.hpp"
params["_graph", "_l"];

private _locationid = getLocationID(_l);

if (!(_locationid in _graph)) then {
	_graph set [_locationid, createHashMap] ;
	
	// Add additional information to location
	_hm = _graph get _locationid ;
	_hm set ["paths", createHashMap] ;

	// Set all other parameters that the locations library looks after
	[_hm, _l] call Sim_fnc_setLocationNode ;
};

_graph get _locationid ;
/*
	Author: HangoverIt

	Description:
		Create a record of a location connected to a node. Creates a node for the destination location
		if it doesn't already exist

	Parameter(s):
		1 (Mandatory): Location graph
		2 (Mandatory): From location (Sim location array)
		3 (Mandatory): To location (Sim location array)
		4 (Mandatory): Distance information between from node and to node
		5 (Mandatory): Array of positions defining the path

	Returns:
	BOOL
*/
#include "..\graph\graph.hpp"
#include "..\location\location.hpp"

params["_graph", "_from", "_to", "_dis", ["_path", [], [[]]]];

private _node = [_graph, _from] call Sim_fnc_createNode ;

// Add the record of the to destination
_paths = _node get "paths" ;
if (getLocationID(_to) in _paths) then {
	_curdis = getPathDistance(_node get getLocationID(_to)) ;
	_dis = _dis min _curdis ; // use the shortest distance
};
_paths set [getLocationID(_to), [_dis, _path]] ;

// Create the reverse record in graph
_node = [_graph, _to] call Sim_fnc_createNode ;
_paths = _node get "paths" ; // get node for destination
if (getLocationID(_from) in _paths) then {
	_curdis = getPathDistance(_paths get getLocationID(_from)) ;
	_dis = _dis min _curdis ;
};
_reversepath = +_path ;
reverse _reversepath ;
_paths set [getLocationID(_from), [_dis, _reversepath]] ;

true ;
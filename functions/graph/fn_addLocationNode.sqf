/*
	Author: HangoverIt

	Description:
	Return all locations for the game

	Parameter(s):
		1 (Mandatory): Location graph
		2 (Mandatory): From location (Sim location array)
		3 (Mandatory): To location (Sim location array)
		4 (Mandatory): Distance information between from node and to node
		5 (Mandatory): Array of positions defining the path

	Returns:
	BOOL
*/
params["_graph", "_from", "_to", "_dis", ["_path", [], [[]]]];

[_graph, _from] call Sim_fnc_createNode ;

// Add the record of the to destination
_nodes = _graph get _from ;
if (_to in _nodes) then {
_curdis = _nodes get _to ;
_dis = _dis min _curdis ;
};
_nodes set [_to, [_dis, _path]] ;

// Create the reverse record in graph
[_graph, _to] call Sim_fnc_createNode ;
_nodes = _graph get _to ; // get node for destination
if (_from in _nodes) then {
_curdis = _nodes get _from ;
_dis = _dis min _curdis ;
};
_nodes set [_from, [_dis, _path]] ;

true ;
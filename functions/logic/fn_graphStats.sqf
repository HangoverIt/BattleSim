/*
	Author: HangoverIt

	Description:
		Queries a graph and gets some stats back

	Parameter(s):
		1: graph
		2: side to generate a score for
		
	Returns:
		Hashmap of locations with stat info
*/
#include "..\location\location.hpp"
#include "..\graph\graph.hpp"
params["_graph", "_side"] ;

private _sidegraph = createHashMap ;

{
	private _hm = _y ;
	private _weight = _hm get "weight" ;
	private _paths = _hm get "paths";
	private _owner = _hm get "owner";
	private _totalconnections = count _paths; // count number of paths
	private _score = _weight + _totalconnections ; // how connected is the location? Increase weight for each connection
	if ([_side, _owner] call BIS_fnc_sideIsEnemy) then {
		_score = 0 ; // cannot go here as enemy hold this location
	}else{
		// Friendly side
		if (_side == _owner) then {
			// exactly the same side at location node
			_score = _score - 1; // reduce the score if already captured
		};
	};
	
	// Check connections for enemy opposing units - this puts the node under threat
	private _enemyConnected = 0 ;
	{
		_destination = _graph get _x ;
		if ([_side, (_destination get "owner")] call BIS_fnc_sideIsEnemy) then {
			_score = _score + 2 ;
			_enemyConnected = _enemyConnected + 1;
		};
	}forEach _paths;
	
	// Update the graph with stats
	_stats = createHashMap;
	_sidegraph set [_x, _stats] ;
	_stats set ["connections", _totalconnections] ;
	_stats set ["enemyconnections", _enemyConnected] ;
	_stats set ["weight", _weight] ; // original weight
	_stats set ["score", _score]; // new score
	_stats set ["owner", _owner] ;
	
}forEach _graph;

_sidegraph;
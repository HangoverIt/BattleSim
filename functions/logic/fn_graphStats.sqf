/*
	Author: HangoverIt

	Description:
		Queries a graph and gets some stats back

	Parameter(s):
		1: graph
		2: side to generate a score for
		3: (optional) start node name
		
	Returns:
		Hashmap of locations with stat info
*/
#include "..\location\location.hpp"
#include "..\graph\graph.hpp"
params["_graph", "_side", ["_startnode", nil]] ;

private _sidegraph = createHashMap ;

{
	private _hm = _y ;
	private _weight = _hm get "weight" ;
	private _paths = _hm get "paths";
	private _owner = _hm get "owner";
	private _position = _hm get "position" ;
	private _totalconnections = count _paths; // count number of paths
	private _score = _weight + _totalconnections ; // how connected is the location? Increase weight for each connection
	if ([_side, _owner] call BIS_fnc_sideIsEnemy) then {
		_score = 0 ; // cannot go here as enemy hold this location
	}else{
		// Friendly side or other
		if (_side == _owner) then {
			// exactly the same side at location node
			_score = _score - 1; // reduce the score if already captured
		}else{
      if (_side == civilian) then {
        // Civilian side are attractive to capture
        _score = _score + 1;
      };
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
	
	// If _startnode is set then increase scores for locations close to start
	// Create a 4 step radius at 1km separation
	if (!isNil "_startnode") then {
		_startnodepos = (_graph get _startnode) get "position" ;
		_distance = _startnodepos distance2D _position ;
		_score = _score + (5 - ((ceil(_distance / 1000)) max 5)) ;
	};
	
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
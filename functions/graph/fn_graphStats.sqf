/*
	Author: HangoverIt

	Description:
	Queries the existing graph and gets some stats back

	Parameter(s):
		None

	Returns:
		Hashmap of locations with stat info
*/
#include "..\location\location.hpp"
_graph = SIMGRAPHVAR;

private _statgraph = createHashMap ;

{
	private _hm = _y ;
	private _weight = _hm get "weight" ;
	private _totalconnections = count (_hm get "paths"); // count number of paths
	private _score = _weight + _totalconnections ; // how connected is the location? Increase weight for each connection
	_statgraph set ["connections", _totalconnections] ;
	_statgraph set ["score", _score];
	
}forEach _graph;
/*
	Author: HangoverIt

	Description:
	Queries the existing graph and gets some stats back

	Parameter(s):
		None

	Returns:
		Hashmap of locations with stat info
*/
#include "../location/location.hpp"
_graph = SIMGRAPHVAR;

private _statgraph = createHashMap ;

{
	private _location = _x ;
	private _hm = _y ;
	private _weight = getLocationWeight(_location);
	private _totalconnections = {_x typeName == "ARRAY"} count _hm ; // count where key is an array
	_weight = _weight + _totalconnections ; // how connected is the location? Increase weight for each connection
	
}forEach _graph;
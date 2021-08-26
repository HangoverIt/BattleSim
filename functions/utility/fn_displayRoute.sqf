/*
	Author: HangoverIt

	Description:
		Shows the shortest route between 2 graph nodes

	Parameter(s):
		1: Graph
		2: Starting node ID
		3: Destination node ID

	Returns:
		Mission array
*/
#include "..\graph\graph.hpp"
params["_graph", "_a", "_b"] ;

private _route = [_graph, _a, _b] call Sim_fnc_getShortestPath;
private _allmarkers = [] ;

_fn_createMarker = {
	params["_pos", ["_colour", "ColorBlack"]] ;

	private _end = createMarkerLocal [format["road%1", _pos], _pos] ;
	_end setMarkerTypeLocal "hd_dot" ;
	_end setMarkerColor _colour ;

	_end ;
};

// Only a route if the array has nodes to travel between
if (count _route > 0) then {
	_prev_node = _graph get (_route select 0) ;
	_first = true ;
	{
		if (_first) then {
			_first = false ;
		}else{
			_paths = _prev_node get "paths" ;
			_road_sections = _paths get _x;
			{
				_allmarkers pushBack ([_x] call _fn_createMarker);
			}forEach getPathArray(_road_sections) ;
			
			_prev_node = _graph get _x ;
		};
	}forEach _route ;
};

_allmarkers;
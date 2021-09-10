/*
	Author: HangoverIt

	Description:
		Given a start node and destination (connected only), return a step in the path that
		is the closest to the coordinates provided. This can help position a unit back on a path or
		resume from following the path.

	Parameter(s):
		1. Graph
		2. Start node
		3. End node (must be immediately connect to the start)
		4. Position
    
	Returns:
		Path node index (zero based for path array). -1 if error
*/
#include "..\graph\graph.hpp"
params["_graph", "_from", "_to", "_pos"] ;

private _idx = -1 ;

private _nodefrom = _graph get _from;
if (isNil "_nodefrom") exitWith {
	diag_log "[BattleSim] Error: findClosestPathCoord given bad from node";
	_idx;
} ;

private _paths = _nodefrom get "paths" ;

_path = _paths get _to ;
if (isNil "_path") exitWith {
	diag_log "[BattleSim] Error: findClosestPathCoord given bad to node";
	_idx;
};

if (count _path == 0) exitWith {
	_idx ; // nothing to check in path, cannot find
};

private _pathSteps = getPathArray(_path) ;

// Quick search to find exact match
{
	if (_x isEqualTo _pos) exitWith {
		_idx = _forEachIndex ;
	};
}forEach _pathSteps;

if (_idx < 0) then {
	// Couldn't find an exact match, run a slower check
	_idx = 0 ;
	_smallestdis = _pos distance (_pathSteps select _idx);
	{
		if (_smallestdis < (_pos distance _x)) then {
			_idx = _forEachIndex ;
			_smallestdis = _pos distance _x;
		};
	}forEach _pathSteps;
};

_idx;
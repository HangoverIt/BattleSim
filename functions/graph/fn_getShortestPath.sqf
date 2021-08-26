/*
	Author: HangoverIt

	Description:
		Get the shortest path between 2 nodes in a graph.
		Use a Dijkstra algorithm to find the path.

	Parameter(s):
		1: Graph
		2: Starting node ID
		3: Destination node ID

	Returns:
		Mission array
*/
#include "..\graph\graph.hpp"
#define getNodeDistance(n) ((n) select 0)
#define isNodeVisited(n) ((n) select 1)
#define getPreviousNode(n) ((n) select 2)
params["_graph", "_a", "_b"] ;

// Create a copy of all nodes from graph into a data set to record visits
private _allNodes = createHashMap;

{
	// distance value, visited flag, previous node
	_allNodes set[_x, [-1,false,""]];
}forEach _graph ;

private _currentNodeID = _a ;
private _toVisitNodes = [] ;
private _smallestDis = -1;
private _returnpath = [] ;

_allNodes set[_a, [0, true, ""]] ; // mark first node as visited and zero distance

while {_currentNodeID != _b} do{
	_paths = (_graph get _currentNodeID) get "paths" ;
	_currentNode = _allNodes get _currentNodeID;
	_currentDis = getNodeDistance(_currentNode);
	_currentPrevNode = getPreviousNode(_currentNode) ;
	// Set this node as visited 
	_currentNode set [1, true] ;
	diag_log format ["_currentNodeID: %1, %2. Connected to %3 paths", _currentNodeID, _currentNode, count _paths] ;

	{
		_lookAtNode = _allNodes get _x ;
		if (!isNodeVisited(_lookAtNode)) then { // Only process unvisited nodes
			_dis = getPathDistance(_y) + _currentDis;
			_prevNode = _currentNodeID;
			// Does node already have a distance?
			if (getNodeDistance(_lookAtNode) != -1 && getNodeDistance(_lookAtNode) < _dis) then { // Retain smaller distance info				
				_dis = getNodeDistance(_lookAtNode) ; // retain
				_prevNode = getPreviousNode(_lookAtNode); // retain last node
			};
			if (getNodeDistance(_lookAtNode) == -1) then {
				// Add new node to potential visit nodes
				_toVisitNodes pushBack [_dis, _x];
				diag_log format ["Adding a node %1 to visit with distance %2. Total nodes to visit %3", _x, _dis, count _toVisitNodes] ;
			};
			// Update record of node
			_allNodes set [_x, [_dis, false, _prevNode]] ;
		};
	}forEach _paths ;
	
	// Assess the next smallest node to visit
	_deleteVistedAt = -1 ;
	_smallestDis = -1; // use -1 as flag for unset distance
	{
		diag_log format ["Evaluating %1 with distance %2 against smallest distance %3", (_x select 1), (_x select 0), _smallestDis] ;
		if ((_x select 0) < _smallestDis || _smallestDis == -1) then {
			_smallestDis = (_x select 0);
			_currentNodeID = (_x select 1) ; // Select new node from shortest distance node in _toVisitNodes array
			_deleteVistedAt = _foreachIndex ;
		};
	}forEach _toVisitNodes;
	if (_deleteVistedAt > -1) then {
		diag_log format ["Removing _toVisitNode %1 and setting to current node", _toVisitNodes select _deleteVistedAt] ;
		_toVisitNodes deleteAt _deleteVistedAt ;
	};
	
	if (_deleteVistedAt == -1) exitWith {false}; // no new nodes to search - no path so exit
};

// Build the return path if the current node arrived at node _b
if (_currentNodeID == _b) then {
	while {_currentNodeID != ""} do {
		_returnpath pushBack _currentNodeID ;
		_currentNodeID = getPreviousNode(_allNodes get _currentNodeID) ;
	};
	reverse _returnpath ; // it was built in reverse so needs reversing to travel from _a to _b
};

_returnpath ;
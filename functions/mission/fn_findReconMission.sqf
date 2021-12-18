/*
	Author: HangoverIt

	Description:
		

	Parameter(s):
		
	Returns:
		Array of [Group, Mission]
*/
#include "..\groups\groups.hpp"
#include "..\graph\graph.hpp"
#include "..\pool\pool.hpp"
#include "..\mission\mission.hpp"
params["_graph", "_sidePool", "_sideGraph", "_sideGroups"]

private _operationalRange = 10000 ; // m

private _grpNode = _graph get getGroupNode(_group) ;
private _currentMission = getGroupMission(_group) ;
if (count _currentMission != 0) exitWith {
	_currentMission ; // already has a mission so just return the one set
};

// Set default mission
// Mission identifier, last change
_currentMission = ["Hold", dateToNumber date] ;



// Get all scores from the side graph and order from smallest to largest (pop stack of locations)
// Side graph needed as scores are based on preferences for each side
//diag_log format ["Create Mission: side graph is type %1, values %2", typeName _sideGraph, _sideGraph] ;
private _grpPos = _grpNode get "position" ;
private _scores = [];
{
	// only consider nodes with certain raidus of unit to keep movements within an operational range
	_node = _graph get _x ;
	if ((_node get "position" distance2D _grpPos) <= _operationalRange) then {
		//diag_log format ["Create Mission: side graph item %1, with data %2", _x,_y] ;
		_scores pushBack [_y get "score",_x];
	};
}forEach _sideGraph ;

_scores sort true ; // Sort smallest to largest locations

if (count _scores > 0) then {
	// Create deploy mission
	_nodePath = [] ;
	// Try all scored nodes
	while {count _nodePath == 0 && count _scores > 0} do {
		_deployTo = (_scores select (count _scores -1)) select 1 ;
		_nodePath = [_graph, getGroupNode(_group), _deployTo] call Sim_fnc_getShortestPath ;
		if (count _nodePath == 0) then {
			_scores deleteAt (count _scores -1);
		};
	};
	// TO DO - take a look at scores at this point. The score may be really low and other missions better than deploy!
	if (count _nodePath > 0) then {
		// Mission identifier, nodes to travel, index of current node, last change (update waypoints) time
		//diag_log format["Create mission: Chosen score %1 at location %2 for side %3, path %4", (_scores select (count _scores -1)) select 0, (_scores select (count _scores -1)) select 1, _side, _nodePath] ;
		_currentMission = ["Deploy", _nodePath, 0, dateToNumber date];
	};
};

//////////////////////////////////////////////////
//
//  Do the final mission setup here after 
//  assessing all the scores and making final mission 
//  decision
//
setGroupMission(_group,_currentMission) ;

switch (getMissionID(_currentMission)) do {
	case "Deploy": {[_group, _graph] spawn Sim_fnc_doDeployMission;};
	case "Hold": {[_group, _graph] spawn Sim_fnc_doHoldMission;} ;
	default {} ;
};


_currentMission;


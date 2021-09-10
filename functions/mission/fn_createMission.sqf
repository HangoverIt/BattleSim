/*
	Author: HangoverIt

	Description:
		Create a new mission and set to the group (also returns the mission set)

	Parameter(s):
		1: Battle group to create the mission
		2: Main graph
		3: side
	Returns:
		Mission array
*/
#include "..\groups\groups.hpp"
#include "..\mission\mission.hpp"
params["_group", "_graph", "_side"] ;

private _currentMission = getGroupMission(_group) ;
if (count _currentMission != 0) exitWith {
	_currentMission ; // already has a mission so just return the one set
};

// Set default mission
// Mission identifier, last change
_currentMission = ["Hold", dateToNumber date] ;

private _sideGraph = [_side] call Sim_fnc_getSideGraph;

// Get all scores from the side graph and order from smallest to largest (pop stack of locations)
// Side graph needed as scores are based on preferences for each side
//diag_log format ["Create Mission: side graph is type %1, values %2", typeName _sideGraph, _sideGraph] ;
private _scores = [];
{
	//diag_log format ["Create Mission: side graph item %1, with data %2", _x,_y] ;
	_scores pushBack [_y get "score",_x];
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
		_currentMission = ["Deploy", _nodePath, 0, dateToNumber date];
	};
};

//////////////////////////////////////////////////
//
//  Do the final mission setup here after 
//  assessing all the scores and making final mission 
//  decision
//
switch (getMissionID(_currentMission)) do {
	case "Deploy": {[_group, _graph] spawn Sim_fnc_doDeployMission;};
	case "Hold": {} ;
	default {} ;
};


setGroupMission(_group,_currentMission) ;
_currentMission;


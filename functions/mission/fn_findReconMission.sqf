/*
	Author: HangoverIt

	Description:
		Check if a valid recon mission is available for an existing group (if set) 
		or if there's an available mission for a new group (if not set)

	Parameter(s):
		1. Graph - game graph with all location nodes
		2. Side - side to check or set mission
		3. MissionName - string of mission identifer - set externally through config
		3. Group (optional) - Battlesim group array to check for mission
	Returns:
		Array of Mission or nullMission (see mission.hpp)
*/
#include "..\groups\groups.hpp"
#include "..\graph\graph.hpp"
#include "..\pool\pool.hpp"
#include "..\mission\mission.hpp"
#include "..\config\config.hpp"
params["_graph", "_side", "_missionName", "_group"];

private _operationalRange = 10000 ; // m

private _grpSet = !(isNil "_group") ;
private _grpNodeName = [_side] call Sim_fnc_getStartNode;
private _grpNode = _graph get _grpNodeName ;

// If a group was passed to the function then check if a mission already exists and set
// the group variables.
if (_grpSet) then {
	if ([_group] call Sim_fnc_hasMission) exitWith {nullMission} ; // Group has a mission - exit
  _grpNodeName = getGroupNode(_group);
	_grpNode = _graph get _grpNodeName ;
	_grpMissions = [_group] call Sim_fnc_availableGroupMissions ;
	if !(_missionName in _grpMissions) exitWith {nullMission} ; // Group doesn't support this mission - exit
}else{
	// No group set, should a mission be deployed?
	_deploy = [_missionName, _side] call Sim_fnc_deployNewGroup ;
	if (!_deploy) exitWith {nullMission} ;
};
private _grpPos = _grpNode get "position" ;
private _sideGraph = [_side] call Sim_fnc_getSideGraph;

// Set null mission
private _currentMission = [] ;

// Get all scores from the side graph and order from smallest to largest (pop stack of locations)
// Side graph needed as scores are based on preferences for each side
//diag_log format ["Create Mission: side graph is type %1, values %2", typeName _sideGraph, _sideGraph] ;

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
		_nodePath = [_graph, _grpNodeName, _deployTo] call Sim_fnc_getShortestPath ;
		if (count _nodePath == 0) then {
			_scores deleteAt (count _scores -1);
		};
	};
	// TO DO - take a look at scores at this point. The score may be really low and other missions better than deploy!
	if (count _nodePath > 0) then {
		// Mission identifier, nodes to travel, index of current node, last change (update waypoints) time
		//diag_log format["Create mission: Chosen score %1 at location %2 for side %3, path %4", (_scores select (count _scores -1)) select 0, (_scores select (count _scores -1)) select 1, _side, _nodePath] ;
		_currentMission = [_missionName, _nodePath, 0, -1, dateToNumber date];
	};
};

//////////////////////////////////////////////////
//
//  Do the final mission setup here after 
//  assessing all the scores and making final mission 
//  decision
//
if (_grpSet) then {
	setGroupMission(_group,_currentMission) ;
};
_currentMission;


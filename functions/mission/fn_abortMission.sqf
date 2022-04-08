/*
	Author: HangoverIt

	Description:
		Stop a mission and revert to last node visited (if exists). Use with missions that have navigated through nodes in graph

	Parameter(s):
		1. Group
    
	Returns:
		Bool
*/
#include "..\groups\groups.hpp"
#include "..\mission\mission.hpp"
#include "..\graph\graph.hpp"
params["_group", "_graph"] ;

// Setup and resume from mission settings
private _mission = getGroupMission(_group);
private _travelNodes = getDeployMissionNodes(_mission) ;
private _currentPos = getGroupPosition(_group) ;
private _idx = getDeployMissionNodeIdx(_mission) ;
private _ret = false ;

// Reset nodes to travel
if (!([_group] call Sim_fnc_isLastMissionNode) && count _travelNodes > 1) then {
	// Set current node and last node as new node route
	if (!([_currentPos] call Sim_fnc_isNullPosition)) then {
		// Group was on the way so add destination to original position
		_travelNodes = [_travelNodes select (_idx+1), _travelNodes select _idx] ;
	}else{
		// Group hadn't moved from last node. Clear of all other nodes and just set current node
		_travelNodes = [_travelNodes select _idx];
	};
	diag_log format ["Aborting to route %1", _travelNodes] ;
	setDeployMissionNodes(_mission, _travelNodes) ;
	setDeployMissionNodeIdx(_mission, 0) ;
	setDeployMissionPathIdx(_mission, -1) ;
	_ret = true ;
}; 

_ret; 

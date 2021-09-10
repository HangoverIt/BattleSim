/*
	Author: HangoverIt

	Description:
		Spawn this function against a group to create a deployment mission. 
		This script handles the entire behaviour for a deployment

	Parameter(s):
		1. Group
    
	Returns:
		Nothing
*/
#include "..\groups\groups.hpp"
#include "..\mission\mission.hpp"
#include "..\graph\graph.hpp"
params["_group", "_graph"] ;

private _min = ((1/365)/24)/60 ;
private _exit = false ;
private _finalTimeout = 30 * _min; // minutes

// Setup and resume from mission settings
private _mission = getGroupMission(_group);
_travelNodes = getDeployMissionNodes(_mission) ;

private _pathIdx = -1;
private _path = [] ;
diag_log format["DoDeploy: Running new mission on group %1", getGroupID(_group)] ;

[_group, true, (_travelNodes select (count _travelNodes - 1))] spawn Sim_fnc_fireMission ;

while {!_exit} do {
	// Handle all timers using in world time. If any time change is made then this will impact missions, but hopefully in a more realistic way
	private _now = dateToNumber date ; 
	
	_mission = getGroupMission(_group) ;
	diag_log format["DoDeploy: Running mission %1", _mission] ;
	// If the mission has changed in anyway then exit the mission now 
	if (count _mission == 0 || getMissionID(_mission) != "Deploy") exitWith {_exit = true};
	
	// if not at the destination then
	//   look at the path from current index to next index location
	//   has enough time elapsed to move to next path position?
	//   if there is another position in the path
	//     move to next path coordinate. Set this against the group location
	//   else move index to next node and set coordinates to [0,0,0] in group

	_idx = getDeployMissionNodeIdx(_mission) ;
	if (_idx < (count _travelNodes - 1)) then {
		// Check for first run and setup the path index to follow
		if (_pathIdx < 0) then {
			_path = getPathArray(((_graph get (_travelNodes select _idx)) get "paths") get(_travelNodes select (_idx + 1))) ; // setup the path
			_currentPos = getGroupPosition(_group) ;
			if (!([_currentPos] call Sim_fnc_isNullPosition)) then {
				// No path index and group has a coordinate, establish the path step to resume on
				_pathIdx = [_graph, (_travelNodes select _idx), (_travelNodes select (_idx +1)), _currentPos] call Sim_fnc_findClosestPathCoord ;
			}else{
				_pathIdx = 0 ;
			};
			diag_log format["DoDeploy: %1 starting new path to %2, at _pathIdx %3", getGroupID(_group), _travelNodes select (_idx + 1), _pathIdx] ;
			[_group] spawn Sim_fnc_fireGroupMoveChange ;
		}else{  // Not the first time setup code
			_pathIdx = _pathIdx + 1;
			if (_pathIdx < (count _path)) then {
				// Take a step
				diag_log format["DoDeploy: %1 moving to %2", getGroupID(_group), _path select _pathIdx] ;
				setGroupPosition(_group, _path select _pathIdx) ;
				[_group] spawn Sim_fnc_fireGroupMoveChange ;
			}else{
				// New node
				diag_log format["DoDeploy: %1 moving to new node", getGroupID(_group)] ;
				[_group, (_travelNodes select _idx), true] spawn Sim_fnc_fireNodeGroupChange ;
				_pathIdx = -1;
				setGroupPosition(_group, []) ;
				_idx = _idx + 1;
				setDeployMissionNodeIdx(_mission, _idx) ;
				setDeployMissionTimestamp(_mission, _now) ;
				setGroupNode(_group, (_travelNodes select _idx));
			};
		};
	}else{
		// At the destination - has the mission timed out?
		diag_log format["DoDeploy: %1 at destination node %2", getGroupID(_group), _travelNodes select (count _travelNodes - 1)] ;
		setGroupNode(_group, (_travelNodes select (count _travelNodes - 1)));
		[_group] spawn Sim_fnc_fireGroupMoveChange ;
		if (_now > (_finalTimeout + getDeployMissionTimestamp(_mission))) then {
			_exit = true ;
		};
	};
	
	sleep 1 ; // avoid overloading the scheduler
};

[_group, false, (_travelNodes select (count _travelNodes - 1))] spawn Sim_fnc_fireMission ;
setGroupMission(_group,[]) ; // make available for new missions
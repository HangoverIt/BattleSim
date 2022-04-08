/*
	Author: HangoverIt

	Description:
		Spawn this function against a group to create a deployment mission. 
		This script handles the entire behaviour for a deployment

	Parameter(s):
		1. Group
    
	Returns:
		Bool
*/
#include "..\groups\groups.hpp"
#include "..\mission\mission.hpp"
#include "..\graph\graph.hpp"
params["_group", "_graph"] ;

private _min = ((1/365)/24)/60 ;
private _exit = false ;
private _abort = false ;
private _finalTimeout = 5 * _min; // minutes

if !([_group] call Sim_fnc_hasMission) exitWith {["fn_doDeployMission: null mission provided. Trace %1", diag_stacktrace] call BIS_fnc_error; false;};

// Setup and resume from mission settings
private _mission = getGroupMission(_group);
private _travelNodes = getDeployMissionNodes(_mission) ;

[_group, true, true, (_travelNodes select (count _travelNodes - 1))] call Sim_fnc_fireMission ;

if (([_group] call Sim_fnc_isLastMissionNode)) then {
	_exit = true ; // not enough nodes to move, already at destination
};

private _now = dateToNumber date ; 

while {!_exit} do {
	// Handle all timers using in world time. If any time change is made then this will impact missions, but hopefully in a more realistic way
	
	
	_mission = getGroupMission(_group) ;
	//diag_log format["DoDeploy: Running mission %1", _mission] ;
	// If the mission has changed in any way then exit the mission now 
	if (count _mission == 0 || getMissionID(_mission) != "Deploy") exitWith {_exit = true};
	
	private _moveRet = [_group] call SIM_fnc_roadMove ;
	if (roadMoveComplete(_moveRet)) exitWith {_exit = true;};
	if (roadMoveUnsafe(_moveRet)) then {
		_abort = true ;
		[_group, _graph] call Sim_fnc_abortMission ;
	};

	sleep 1 ; // avoid overloading the scheduler
};
[_group] spawn Sim_fnc_fireGroupMoveChange ;
setDeployMissionTimestamp(_mission, _now) ;

if (!_abort) then {
	waitUntil{sleep 10; _now = dateToNumber date ; _now > (_finalTimeout + getDeployMissionTimestamp(_mission));};
};

[_group, false, !_abort, (_travelNodes select getDeployMissionNodeIdx(_mission))] spawn Sim_fnc_fireMission ;

[_group] call Sim_fnc_removeMission ; // Clear the mission from group

true ;
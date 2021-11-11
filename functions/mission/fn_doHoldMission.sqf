/*
	Author: HangoverIt

	Description:
		Spawn this function against a group to create a hold mission. 

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

if ([_group] call Sim_fnc_hasMission) exitWith {["fn_doDeployMission: null mission provided. Trace %1", diag_stacktrace] call BIS_fnc_error; false;};

[_group, true, true] spawn Sim_fnc_fireMission ;

// Setup and resume from mission settings
private _mission = getGroupMission(_group);

waitUntil{sleep 10; _now = dateToNumber date ; _now > (_finalTimeout + getHoldMissionTimestamp(_mission));};

[_group, false, true] spawn Sim_fnc_fireMission ;

[_group] call Sim_fnc_removeMission ; // Clear the mission from group

true ;
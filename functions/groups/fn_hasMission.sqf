/*
	Author: HangoverIt

	Description:
		Returns true if a group has a mission

	Parameter(s):
		1: battle group
    
	Returns:
		bool
*/
#include "..\groups\groups.hpp"
params["_group"];

_mission = getGroupMission(_group);

if ([_mission] call Sim_fnc_isNullMission) exitWith {
	// No mission set
	false ;
};

true ;
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

_mission = getGroupMission(_grp);

if (count _mission == 0) exitWith {
	// No mission set - empty array
	false ;
};

true ;
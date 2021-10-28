/*
	Author: HangoverIt

	Description:
		Check if mission current node is the last node.
		Refers to index in mission settings or uses the optional node index parameter

	Parameter(s):
		1. Group
		2. (Optional) Node index
    
	Returns:
		BOOL
*/
#include "..\groups\groups.hpp"
#include "..\mission\mission.hpp"
params["_group", ["_nodeidx", -1]] ;

private _mission = getGroupMission(_group);
private _travelNodes = getDeployMissionNodes(_mission) ;
private _idx = getDeployMissionNodeIdx(_mission) ;

if (_nodeidx < 0) then {
	_nodeidx = _idx ;
};

private _ret = (_nodeidx >= (count _travelNodes - 1));
_ret ;
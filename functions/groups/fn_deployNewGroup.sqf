/*
	Author: HangoverIt

	Description:
		Given a mission identifier, should a new group be deployed?
		Checks deployed units for supported mission type. If not enough then returns true, else false.
		<old - remove>
	Parameter(s):
		1. Mission type - string uniquely identifying a config mission type
		2. Side 
		
	Returns:
		Bool
*/
#include "..\config\config.hpp"
#include "..\groupinfo\groupinfo.hpp"
params["_missionType","_side"] ;

private _handlers = [] call Sim_fnc_getMissionHandlers ;
if (isNil "_handlers") exitWith {false} ; // Error state, something wrong in config

_missionHandler = _handlers get _missionName ;
if (isNil "_missionHandler") exitWith {false} ; // Cannot proceed if mission is unknown

_maxHandlers = getConfigMissionMax(_missionHandler) ;

private _supportedUnits = [_missionType] call Sim_fnc_unitsSupportingMission ;

private _count = 0 ;
private _sideGraph = [_side] call Sim_fnc_getSideGraph;
{
	_group = _x ;
	_groupType = getGroupInfoID(getGroupInfo(_group)) ;
	if (_groupType in _supportedUnits) then {
		_count = _count + 1;
	};
}forEach _sideGraph ;

_count < _maxHandlers ;
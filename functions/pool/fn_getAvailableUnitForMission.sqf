/*
	Author: HangoverIt

	Description:
		Provide a mission type and the pool will look for an available unit type to deploy.
		If no unit available then returns empty string

	Parameter(s):
		1. Mission Type string
		2. Side
    
	Returns:
		String - name of unit or "" if no match
*/
#include "..\pool\pool.hpp"
#include "..\mission\mission.hpp"
params["_mission", "_side"] ;

if ([_mission] call Sim_fnc_isNullMission) exitWith {""};

private _missionType = getMissionID(_mission);

private _sidePool = [_side] call Sim_fnc_getSidePool ;

private _config = [] call Sim_fnc_getConfig ;

private _supportedMissions = _config get "supported_missions" ;
if (isNil "_supportedMissions") exitWith {""} ; // config issue, no supported missions found in config

private _unitTypes = [] ;
private _bestFits = [] ;
private _bestFitPriority = -1 ;
// Establish best fit for the mission (lower index match is better)
// List will have some mixed priorities whilst the best fit is worked out
{
	_missions = _y ;
	_unitType = _x ;
	_countUnitAvailable = _sidePool get _unitType ;
	if !(isNil "_countUnitAvailable") then {
		if (_countUnitAvailable > 0) then {
			{
				if (_missionType == _x) exitWith {
					if (_bestFitPriority == -1 || _bestFitPriority <= _forEachIndex) then {
						_bestFitPriority = _forEachIndex ;
						_bestFits pushBack [_unitType, _bestFitPriority] ;
					};
				};		
			}forEach _missions ;
		};
	};

}forEach _supportedMissions ;

// Only include unit types that match the best fit and available in the pool
// More than one unit could match
{
	_unitType = (_x select 0) ;
	if ((_x select 1) == _bestFitPriority) then {
		_unitTypes pushBack _unitType ;
	};

}forEach _bestFits ;

if (count _unitTypes == 0) exitWith {""} ;

diag_log format["DEBUG: GetAvailableUnitForMission returning one of %1", _unitTypes] ;
// if more than one suitable unit type then select one at random
selectRandom _unitTypes ;
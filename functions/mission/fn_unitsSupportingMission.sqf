/*
	Author: HangoverIt

	Description:
		Reverse look up of config to map a mission to unit types that support it

	Parameter(s):
		1. Mission type string
    
	Returns:
		Array of unit types that support the mission
*/
params["_missionType"];

private _unitTypes = [] ;
private _config = [] Sim_fnc_getConfig ;

private _supportedMissions = _config get "supported_missions" ;
if (isNil "_supportedMissions") exitWith {_unitTypes} ; // config issue, no supported missions found in config

{
	if (_missionType in _x) then {
		_unitTypes pushBack _y ;
	};
}forEach _supportedMissions ;

_unitTypes;


 

/*
	Author: HangoverIt

	Description:
		Get array of map airports based on worldmap

	Parameter(s):
		None

	Returns:
		Array of [position, direction]
*/

private _airfields = [[getArray(configfile >> "CfgWorlds" >> worldname >> "ilsPosition"),getArray(configfile >> "CfgWorlds" >> worldname >> "ilsDirection")]];

private _airCfg = (configfile >> "CfgWorlds" >> worldname >> "SecondaryAirports");
for "_i" from 0 to (count _airCfg - 1) do {
	_airfields pushBack [getArray((_airCfg select _i) >> "ilsPosition"),getArray((_airCfg select _i) >> "ilsDirection")];
};

_airfields ;
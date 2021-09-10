/*
	Author: HangoverIt

	Description:
	Create a new battle group

	Parameter(s):
		1: Side to create group
		2: Template of battle group
		3: Starting location in graph

	Returns:
	BOOL
*/
#include "..\location\location.hpp"
params["_side", "_template", "_graphid"] ;

private _battlegrp = [] call Sim_fnc_getAllGroups;

if (!(_side in _battlegrp)) then {
  _battlegrp set[_side, createHashMap];
};
private _grps = _battlegrp get _side ; 

_id = [_side] call Sim_fnc_assignID ;

// Graph position, Mission, State, Group Composition, spawned group array, actual location (optional), side
_grps set[_id, [_id, _graphid, [], "stopped", _template, [], [0,0,0], _side]];

true ;
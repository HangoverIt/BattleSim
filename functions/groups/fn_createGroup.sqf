/*
	Author: HangoverIt

	Description:
	Create a new battle group

	Parameter(s):
		1: Side to create group
		2: Template of battle group
		3: Starting location in graph (optional)

	Returns:
	BOOL
*/
#include "..\groups\groups.hpp"
#include "..\location\location.hpp"
params["_side", "_template", ["_graphid", ""]] ;

if (isNil BATTLEGROUPS) then {
  CREATEBATTLEGRP;
};
private _battlegrp = BATTLEGRPVAR;

if (!(_side in _battlegrp)) then {
  _battlegrp set[_side, createHashMap];
};
private _grps = _battlegrp get _side ; 

_id = [_side] call Sim_fnc_assignID ;

// Graph position, Mission, State, Group Composition, spawned group array
_grps set[_id, [_id, "_graphid", [], "stopped", _template, []]];

true ;
/*
	Author: HangoverIt

	Description:
	Create a new battle group

	Parameter(s):
		1: Side to create group
		2: Template of battle group
		3: Starting location in graph

	Returns:
		Group array or Nothing
*/
#include "..\groupinfo\groupinfo.hpp"
params["_side", "_template", "_graphid"] ;

private _sidePool = [_side] call Sim_fnc_getSidePool ;
_unitType = getGroupInfoID(_template) ;
_inPool = _sidePool get _unitType ;
if (isNil "_inPool") exitWith {Nil}; // cannot find this unit type in the pool - do not create
if (_inPool <= 0) exitWith {Nil} ; // not enough of this type to create new

private _battlegrp = [] call Sim_fnc_getAllGroups;

if (!(_side in _battlegrp)) then {
  _battlegrp set[_side, createHashMap];
};
private _grps = _battlegrp get _side ; 

_id = [_side] call Sim_fnc_assignID ;

// Graph ID, position, Mission, State, Group Composition, spawned group array, actual location (optional), side
_grps set[_id, [_id, _graphid, [], "stopped", _template, [], [0,0,0], _side]];

// Get new group and fire the node group change
_newGrp = [_side, _id] call Sim_fnc_getGroup ;
if (!isNil "_newGrp") then {
	[_newGrp, _graphid, true] call Sim_fnc_fireNodeGroupChange ;
	_sidePool set [_unitType, _inPool - 1] ; // check out the unit type from the pool and decrement count
};

_newGrp ;
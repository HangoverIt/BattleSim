/*
	Author: HangoverIt

	Description:
	Create a new battle group

	Parameter(s):
		1: Side to create group
    2: Template of battle group
    3: Chosen location to start 

	Returns:
	BOOL
*/
#include "groups.hpp"
#include "../location/location.hpp"
params["_side", "_template", "_location"] ;

if (isNil BATTLEGROUPS) then {
  CREATEBATTLEGRP;
};
_battlegrp = BATTLEGRPVAR;

if (!(_side in _battlegrp)) then {
  _battlegrp set[_side, createHashMap];
}
private _grps = _battlegrp get [_side] ; 

_id = [_side] call Sim_fnc_assignID ;

_grps set[_id, [getLocationPos(_location), _template]];

true ;
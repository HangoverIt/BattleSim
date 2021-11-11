/*
	Author: HangoverIt

	Description:
    Get a named group

	Parameter(s):
    1. Side
	2. ID
    
	Returns:
    Group array or Nil if no group exists
*/
params["_side", "_id"];

private _grp = nil ;
private _grps = [_side] call Sim_fnc_getSideGroups ;

if (!(isNil "_grps")) then {
	_grp = _grps get _id ;
};

_grp;
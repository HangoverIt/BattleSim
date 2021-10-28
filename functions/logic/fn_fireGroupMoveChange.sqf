/*
	Author: HangoverIt

	Description:
		Called by internal code to trigger BattleSim events. 
		This triggers when a group has moved

	Parameter(s):
		1. Group which has moved
    
	Returns:
		BOOL
*/
#include "..\groups\groups.hpp"
#include "..\graph\graph.hpp"
params["_group"];

private _side = getGroupSide(_group) ;

private _pos = [_group] call Sim_fnc_getGroupPosition ;

// TO DO - complete the ability to fire code registered as event handlers in the BattleSim

// Temp code for testing

private _mkrid = format["_grp%1%2",getGroupID(_group),_side];
private _mkr = createMarkerLocal [_mkrid, _pos] ;
_mkr = _mkrid;
//diag_log format["Creating group %1 marker at %2 name %3", getGroupID(_group), _pos, _mkr] ;

_mkr setMarkerShapeLocal "ICON" ;
_mkr setMarkerTypeLocal "n_armor";
if (_side == east) then {
	_mkr setMarkerTypeLocal "o_armor" ;
};
if (_side == west) then {
	_mkr setMarkerTypeLocal "b_armor" ;
};

_mkr setMarkerPos _pos ;

true;
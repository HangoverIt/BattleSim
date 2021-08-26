/*
	Author: HangoverIt

	Description:
    Get the hash of all groups on a side

	Parameter(s):
    1. Side
    
	Returns:
    HashMap or Nil
*/
params["_side"];

_battlegrp = BATTLEGRPVAR;
if (!(_side in _battlegrp)) then {
  _battlegrp set[_side, createHashMap];
};
private _grps = _battlegrp get _side ; 

_grps ;


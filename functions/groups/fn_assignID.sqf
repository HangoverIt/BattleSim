/*
	Author: HangoverIt

	Description:
    Create a new identifier for a group on a side

	Parameter(s):
    1. Side
    
	Returns:
    HashMap
*/
params["_side"] ;
_grpids = ["Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliet", "Kilo", "Lima", "Mike", "November", "Oscer", "Papa", "Quebeq", "Romeo", "September", "Tango", "Uniform", "Victor", "Wiskey", "X-Ray", "Yankiee", "Zulu"];

_grpid = _grpids select 0 ;

_grps = [_side] call Sim_fnc_getSideGroups;
{
  if (!(_x in _grps)) exitWith {
    _grpid = _x ;
  };
}forEach _grpids;

_grpid;
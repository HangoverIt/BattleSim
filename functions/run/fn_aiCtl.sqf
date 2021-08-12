/*
	Author: HangoverIt

	Description:
		Central process to run ai checks and control

	Parameter(s):
		None
    
	Returns:
		bool
*/
#include "groups.hpp"
while {true} do {
	_sides = [] call Sim_fnc_getAllGroups ;
	{
		_side = _x ;
		_groups = _y ;
		{
			_grpid = _x ;
			_grp = _y ;
			if (!isSpawned(_grp)) then {
				
			};			
		}forEach _groups ;
	}forEach _sides ;

	sleep 10 ;
};
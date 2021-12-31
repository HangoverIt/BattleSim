/*
	Author: HangoverIt

	Description:
		Procedure to check for new missions and create if units available

	Parameter(s):
		None
	Returns:
		Boolean
*/
#include "..\groups\groups.hpp"
#include "..\mission\mission.hpp"

private _missionHandlers = [] call Sim_fnc_getMissionHandlers ;

{
	_side = _x ;

	// Is a new mission needed?
	{
		_missionType = _y;
		_missionFinder = getConfigMissionFind(_x) ;
		_missionExec = getConfigMissionRun(_x) ;
		_mission = [_graph, _side, _missionType] call _missionFinder ;
		if !([_mission] call isNullMission) then {
			_unitType = [_mission, _side] call Sim_fnc_getAvailableUnitForMission ;
			if (_unitType != "") then {
				_newGrp = [_side, [_side,_unitType] call Sim_fnc_createDefaultTemplate, [_side] call Sim_fnc_getStartNode] call Sim_fnc_createGroup ; 
				setGroupMission(_newGrp,_mission) ;
				[_newGrp, _graph] spawn _missionExec ;
			};
		};
	}forEach _missionHandlers ;
} foreach ([] call Sim_fnc_getFactionSides);

_sides = [] call Sim_fnc_getAllGroups ;
{
	_side = _x ;
	_groups = _y ;

	{
		_grpid = _x ;
		_grp = _y ;
		if(!([_grp] call Sim_fnc_hasMission)) then {
			{
				_missionType = _y;
				_missionFinder = getConfigMissionFind(_x) ;
				_missionExec = getConfigMissionRun(_x) ;
				_mission = [_graph, _side, _missionType, _grp] call _missionFinder ; // Mission finder will set the mission to the group
				[_grp, _graph] spawn _missionExec ;
			}forEach _missionHandlers ;
		};
	}forEach _groups ;
}forEach _sides ;

true;
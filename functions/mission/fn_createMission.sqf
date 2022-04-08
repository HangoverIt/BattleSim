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
#include "..\config\config.hpp"

private _missionHandlers = [] call Sim_fnc_getMissionHandlers ;
{
	_side = _x ;

	// Is a new mission needed?
	{
		_missionType = _x;
		_missionFinder = getConfigMissionFind(_y) ;
		_missionExec = getConfigMissionRun(_y) ;
		_mission = [_graph, _side, _missionType] call _missionFinder ;
		diag_log format["DEBUG: Creating new mission %1", _mission] ;
		if !([_mission] call Sim_fnc_isNullMission) then {
			_unitType = [_mission, _side] call Sim_fnc_getAvailableUnitForMission ;
			diag_log format["DEBUG: Unit type for mission %1", _unitType] ;
			if (_unitType != "") then {
				_newGrp = [_side, [_side,_unitType] call Sim_fnc_createDefaultTemplate, [_side] call Sim_fnc_getStartNode] call Sim_fnc_createGroup ; 
				diag_log format["DEBUG: Creating new group %1", _newGrp] ;
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
				_missionType = _x;
				_missionFinder = getConfigMissionFind(_y) ;
				_missionExec = getConfigMissionRun(_y) ;
				_mission = [_graph, _side, _missionType, _grp] call _missionFinder ; // Mission finder will set the mission to the group
				[_grp, _graph] spawn _missionExec ;
			}forEach _missionHandlers ;
		};
	}forEach _groups ;
}forEach _sides ;

true;
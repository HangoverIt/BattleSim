/*
	Author: HangoverIt

	Description:
		Uses the pool and existing groups to match a group to a mission and pass on to createMission
		This function may define new groups from the pool if required

	Parameter(s):
		1: Graph
		2: Side
	Returns:
		Array of [Group, Mission] or nullMission if none available
*/
#include "..\groups\groups.hpp"
#include "..\graph\graph.hpp"
#include "..\pool\pool.hpp"
#include "..\mission\mission.hpp"
params["_graph", "_side"] ;

private _sidePool = [_side] call Sim_fnc_getSidePool ;
private _sideGraph = [_side] call Sim_fnc_getSideGraph;
private _sideGroups = [_side] call Sim_fnc_getSideGroups ;

private _randomSearch = [Sim_fnc_findReconMission, 
						Sim_fnc_findAssaultMission, 
						Sim_fnc_findAirMission] ;
						

private _missionAndGroup = nullMission ;
private _maxFind = 5;
while { ([_missionAndGroup] call Sim_fnc_isNullMission) && _maxFind > 0} do {
	private _missionAndGroup = [_graph, _sidePool, _sideGraph, _sideGroups] call (selectRandom _randomSearch) ;
	sleep 1; // Throttle the finder
	_maxFind = _maxFind - 1;
};

_missionAndGroup ;
/*
	Author: HangoverIt

	Description:
		Get path from current node to next node

	Parameter(s):
		1 (Mandatory): Group with existing mission
		2 (Mandatory): Location graph hashmap

	Returns:
		Array of path coordinates or [] if no path
*/
#include "..\groups\groups.hpp"
#include "..\mission\mission.hpp"
#include "..\graph\graph.hpp"
params["_group", "_graph"] ;

private _mission = getGroupMission(_group);
private _travelNodes = getDeployMissionNodes(_mission) ;
private _idx = getDeployMissionNodeIdx(_mission) ;

if (((count _travelNodes) - _idx) < 2) exitWith {[]} ; // not enough nodes remaining to get path

private _node = _graph get (_travelNodes select _idx);
if (isNil "_node") exitWith {[]} ; // Node does not exist
_destinationNode = (_node get "paths") get (_travelNodes select (_idx + 1)) ;
if (isNil "_destinationNode") exitWith {[]} ; // Destination node does not exist

_path = getPathArray(_destinationNode) ;

_path;
/*
	Author: HangoverIt

	Description:
		Called by internal code to trigger BattleSim events. 
		This triggers when a mission is started

	Parameter(s):
		1. Group with mission
		2. Bool, mission started
		2. (Optional) The node ID associated with the mission
    
	Returns:
		BOOL
*/
#include "..\groups\groups.hpp"
params["_group", "_started", ["_nodeId", ""]];

private _side = getGroupSide(_group) ;
private _sideGraph = [_side] call Sim_fnc_getSideGraph ;
if (_nodeId != "") then {
	private _node = _sideGraph get _nodeId ;
	private _score = _node get "score" ;
	_node set ["score", _score + ([1, -1] select _started)]; // Deduct one point to reduce chance of further missions or add if mission ended
};

// TO DO - complete the ability to fire code registered as event handlers in the BattleSim

true;
/*
	Author: HangoverIt

	Description:
		Called by internal code to trigger BattleSim events. 
		This triggers when a mission is started

	Parameter(s):
		1. Group with mission
		2. Bool, mission started (true then just started or false it has finished)
		3. Bool, mission successful (true then completed or false and it was failed/aborted)
		4. (Optional) The node ID associated with the mission
    
	Returns:
		BOOL
*/
#include "..\groups\groups.hpp"
#include "..\logic\logic.hpp"
params["_group", "_started", "_successful", ["_nodeId", ""]];

private _side = getGroupSide(_group) ;
private _sideGraph = [_side] call Sim_fnc_getSideGraph ;
if (_nodeId != "") then {
	private _node = _sideGraph get _nodeId ;
	private _score = _node get "score" ;
	_node set ["score", _score + ([SIM_NODE_MISSION, -SIM_NODE_MISSION] select _started)]; // Deduct one point to reduce chance of further missions or add if mission ended
};

// TO DO - complete the ability to fire code registered as event handlers in the BattleSim

true;
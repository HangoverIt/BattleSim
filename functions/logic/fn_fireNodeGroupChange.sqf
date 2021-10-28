/*
	Author: HangoverIt

	Description:
		Called by internal code to trigger BattleSim events. 
		This triggers when a node has a change 
		- Battle group arrived or left node

	Parameter(s):
		1. Group which has arrived or left
		2. The node ID from the graph which has been left or arrived at
		3. Boolean set to true if arriving or false if leaving
    
	Returns:
		BOOL
*/
#include "..\groups\groups.hpp"
#include "..\logic\logic.hpp"
params["_group", "_nodeId", "_arrived"];

private _side = getGroupSide(_group) ;
private _sideGraph = [_side] call Sim_fnc_getSideGraph ;
private _node = _sideGraph get _nodeId ;
private _score = _node get "score" ;
_score = _score + ([SIM_NODE_DEFENDER, -SIM_NODE_DEFENDER] select _arrived); // Deduct one for an arriving group and add one for leaving

_node set ["score", _score]; // Set score back into graph

// TO DO - complete the ability to fire code registered as event handlers in the BattleSim

/*
	Author: HangoverIt

	Description:
		Called by internal code to trigger BattleSim events. 
		This triggers when a node has a change 
		- Node has been captured

	Parameter(s):
		1. Group which has arrived or left
		2. The node ID from the graph which has been captured and had ownership change
		3. Previous ownership
    
	Returns:
		BOOL
*/
#include "..\groups\groups.hpp"
params["_group", "_nodeId", "_lastowner"];

private _side = getGroupSide(_group) ;
private _sideGraph = [_side] call Sim_fnc_getSideGraph ;
private _node = _sideGraph get _nodeId ;
private _score = _node get "score" ;
_score = _score - 1; // drop the score on own side once captured
_node set ["score", _score]; // Set score back into graph

if (_side == east || _side == west) 
private _impactside = [east,west,resistance] - [_side];

{
  _sideGraph = [_x] call Sim_fnc_getSideGraph ;
  _node = _sideGraph get _nodeId ;
  if (!isNil "_node") then { // Check side graph exists
    _node set ["score", 0]; // Set score to zero for losing size - assume zero aggression
  };
}forEach _impactside ;


// TO DO - complete the ability to fire code registered as event handlers in the BattleSim

true;
/*
	Author: HangoverIt

	Description:
		Called by internal code to trigger BattleSim events. 
		This triggers when a node has a change 
		- Node has been captured

	Parameter(s):
		1. Group which has captured the node
		2. The node ID from the graph which has been captured and had ownership change
    
	Returns:
		BOOL
*/
#include "..\groups\groups.hpp"
#include "..\logic\logic.hpp"
#include "..\graph\graph.hpp"
params["_group", "_nodeId"];

//diag_log format["Firing node capture: group %1, nodeid %2", _group, _nodeId] ;

private _graph = SIMGRAPHVAR ;
private _node = _graph get _nodeId;
private _side = getGroupSide(_group) ;
private _paths = _node get "paths";
private _lastowner = (_node get "owner");

if (_side == _lastowner) exitWith {diag_log format["Node %1 is already owned by %2, group %3 of side %4 attempting capture!", _nodeId, (_node get "owner"), getGroupID(_group), getGroupSide(_group)]; false;};

// Process the capture
_node set ["owner", _side] ;

private _impactside = [] call Sim_fnc_getFactionSides;

// Modify all side graphs for the captured node
{
	_currentSide = _x ;
	_destinationSideGraph = [_currentSide] call Sim_fnc_getSideGraph ;
	if (!isNil "_destinationSideGraph") then { // Check side graph exists
		_sideNode = _destinationSideGraph get _nodeId ;
		if (!isNil "_sideNode") then { // Check the node exists in side graph
			_score = _sideNode get "score";
			if ([_side, _currentSide] call BIS_fnc_sideIsEnemy) then {
				_score = _score + SIM_NODE_CAPTURED ;  //increase score of node
			}else{
				// Side is friendly to capture group, but check if it was previously enemy
				if ([_lastowner, _currentSide] call BIS_fnc_sideIsEnemy) then {
					_score = _score - SIM_NODE_CAPTURED ; // now captured for own alliance
				};
			};
			_sideNode set ["score", _score]; // Change score for side
		
			// Re-evaluated connected enemy to captured node for each side
			_connectedEnemy = 0 ;
			{
				_nodeOwner = (_graph get _x) get "owner";
				if ([_currentSide, _nodeOwner] call BIS_fnc_sideIsEnemy) then {
					_connectedEnemy = _connectedEnemy + 1;
				};
			}forEach _paths ;
			_sideNode set ["enemyconnections", _connectedEnemy] ;
		};
	};

}forEach _impactside ;

// Check connections for enemy opposing units - this puts the node under threat
{
	_enemyConnected = 0 ;
	_destinationNode = _graph get _x ;
	_destinationSide = _destinationNode get "owner";
	_destinationSideGraph = [_destinationSide] call Sim_fnc_getSideGraph ;
	if (!isNil "_destinationSideGraph") then {
		_destinationSideNode = _destinationSideGraph get _x ;
		if (!isNil "_destinationSideNode") then {
			_score = _destinationSideNode get "score" ;
			
			// Remove previous score modifier
			if ([_destinationSide, _lastowner] call BIS_fnc_sideIsEnemy) then {
				_score = _score - SIM_NODE_ENEMY_CONNECTED;
				_enemyConnected = _enemyConnected - 1 ;
			};
			// If new owner is enemy to destination node then add score
			if ([_destinationSide, _side] call BIS_fnc_sideIsEnemy) then {
				_score = _score + SIM_NODE_ENEMY_CONNECTED ;
				_enemyConnected = _enemyConnected + 1;
			};
			
			_destinationSideNode set ["score", _score] ;
			_enemyConnections = (_destinationSideNode get "enemyconnections") + _enemyConnected ;
			_destinationSideNode set ["enemyconnections", _enemyConnections] ;
		};
	};
}forEach _paths;

// TO DO - complete the ability to fire code registered as event handlers in the BattleSim

true;
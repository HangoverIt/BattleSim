/*
	Author: HangoverIt

	Description:
		Manage movement of a group according to provided mission

	Parameter(s):
		1. Group to move
		2. (Optional) Safe: true if unit is to not proceed with enemy at node, false if careless and attacking
    
	Returns:
		Array of boolean [isComplete, isUnsafe];
*/
params["_group", ["_safe", true]];

private _captureTimeout = 1 * _min ; // minutes

private _mission = getGroupMission(_group);
private _travelNodes = getDeployMissionNodes(_mission) ;

private _pathIdx = getDeployMissionPathIdx(_mission);
private _path = [] ;

private _enemyAtNode = false ;
//diag_log format["DoDeploy: Running new mission on group %1", getGroupID(_group)] ;
_idx = getDeployMissionNodeIdx(_mission) ;
if (_idx == 0) then {
	_idx = _idx + 1; // Move to next node index if at start node
};

_now = dateToNumber date ; 

if (!([_group] call Sim_fnc_isLastMissionNode)) then {
	private _node = _graph get (_travelNodes select _idx);
	private _owner = _node get "owner" ;
	
	// Check destination for enemy capture
	if (([getGroupSide(_group), _owner] call BIS_fnc_sideIsEnemy)) then {
		// Enemy is at destination node. 
		_enemyAtNode = true;
	};
	
	if (_enemyAtNode && !_safe) then {
		// Path index could be -1 if unit needs resyncing with path - happends when AI has despawned back into simulation
		// Alternatively -1 will be used for the start of a new path
		if (_pathIdx < 0) then {
			_path = [_group, _graph] call Sim_fnc_getPathFromTo ;
			_currentPos = getGroupPosition(_group) ;
			if (!([_currentPos] call Sim_fnc_isNullPosition)) then {
				// No path index and group has a coordinate, establish the path step to resume on
				_pathIdx = [_graph, (_travelNodes select _idx - 1), (_travelNodes select _idx), _currentPos] call Sim_fnc_findClosestPathCoord ; // Helper func - getDeployMissionNode(mission, index)
			}else{
				_pathIdx = 0 ; // Group is at the node so start from first path marker
			};
			//diag_log format["DoDeploy: %1 starting new path to %2, at _pathIdx %3", getGroupID(_group), _travelNodes select (_idx + 1), _pathIdx] ;
		}else{  // Not the first time setup code
			// Handle node change event
			if (_pathIdx == 0 && _idx > 0) then {
				//diag_log format ["DoDeploy: Leaving node index %1 for node %2", _idx - 1, _travelNodes select _idx];
				[_group, (_travelNodes select (_idx - 1)), false] spawn Sim_fnc_fireNodeGroupChange ; // leaving node
			};
			_pathIdx = _pathIdx + 1; // Increment path index to move
			if (_pathIdx < (count _path)) then { // To Do: Helper func - is at end of path?
				// Take a step
				//diag_log format["DoDeploy: %1 moving to %2", getGroupID(_group), _path select _pathIdx] ;
				setGroupPosition(_group, _path select _pathIdx) ;
			}else{
				// New node
				//diag_log format["DoDeploy: %1 arrived at %2", getGroupID(_group), (_travelNodes select _idx)] ;
				[_group, (_travelNodes select _idx), true] spawn Sim_fnc_fireNodeGroupChange ;

				_pathIdx = -1; // indicate a new path is needed
				setGroupPosition(_group, []) ; // Helper fnc - reset position
				setGroupNode(_group, (_travelNodes select _idx ));

				// To Do: Determine what should happen if this is enemy??? Although the checks above stop travel to enemy
				_groupOwner = getGroupSide(_group);
				diag_log format["DoDeploy: Group %1 on side %2 passing through node %3, owned by %4", getGroupID(_group), _groupOwner, _travelNodes select _idx , _owner];
				if (_owner != _groupOwner) then {
					//diag_log format["DoDeploy: Group %1 on side %2 capturing node %3, owned by %4", getGroupID(_group), _groupOwner, _travelNodes select _idx, _owner];
					[_group] spawn Sim_fnc_fireGroupMoveChange ;
					setDeployMissionTimestamp(_mission, _now) ;
					// Wait until node is captured early by own side or capture timeout reached
					waitUntil {sleep 1; _now = dateToNumber date ;(_node get "owner") == _groupOwner || _now > (_captureTimeout + getDeployMissionTimestamp(_mission));} ;
					if ((_node get "owner") != _groupOwner) then {
						diag_log format["DoDeploy: Group %1 on side %2 captured node %3, owned by %4", getGroupID(_group), _groupOwner, _travelNodes select _idx , _owner];
						[_group, (_travelNodes select _idx)] spawn Sim_fnc_fireNodeCapture;
					};
				}; 
				
				// Set the index to now be the current index node as the group has arrived
				setDeployMissionNodeIdx(_mission, _idx) ;
				setDeployMissionTimestamp(_mission, _now) ;
				
				_idx = _idx + 1;
			};
		};
	};
	setDeployMissionPathIdx(_mission, _pathIdx);
}else{
	// At the destination
	private _finalNodeId = _travelNodes select getDeployMissionNodeIdx(_mission);
	private _node = _graph get _finalNodeId ;
	private _owner = _node get "owner" ;
	diag_log format["DoDeploy: %1 %2 at final destination node %3", getGroupID(_group), getGroupSide(_group), _finalNodeId] ;
	setGroupPosition(_group, []) ;
	setGroupNode(_group, _finalNodeId);
	
	diag_log format["Fire capture and group change at index %1, max node count %2, firing node %3", getDeployMissionNodeIdx(_mission), count _travelNodes, _finalNodeId] ;
	[_group, _finalNodeId, true] spawn Sim_fnc_fireNodeGroupChange ;
	setDeployMissionTimestamp(_mission, _now) ;
	_groupOwner = getGroupSide(_group);
	// Wait until node is captured early by own side or capture timeout reached
	waitUntil {sleep 1; _now = dateToNumber date ;(_node get "owner") == _groupOwner || _now > (_captureTimeout + getDeployMissionTimestamp(_mission));} ;
	if ((_node get "owner") != _groupOwner) then {
		diag_log format["DoDeploy: Group %1 on side %2 captured node %3, owned by %4", getGroupID(_group), _groupOwner, _finalNodeId, _owner];
		[_group, _finalNodeId] spawn Sim_fnc_fireNodeCapture;
	};
	
};
// Trigger event for movement
[_group] spawn Sim_fnc_fireGroupMoveChange ;
/*
	Author: HangoverIt

	Description:
		Spawn this function against a group to create a deployment mission. 
		This script handles the entire behaviour for a deployment

	Parameter(s):
		1. Group
    
	Returns:
		Bool
*/
#include "..\groups\groups.hpp"
#include "..\mission\mission.hpp"
#include "..\graph\graph.hpp"
params["_group", "_graph"] ;

private _min = ((1/365)/24)/60 ;
private _exit = false ;
private _abort = false ;
private _finalTimeout = 5 * _min; // minutes
private _captureTimeout = 1 * _min ; // minutes

if !([_group] call Sim_fnc_hasMission) exitWith {["fn_doDeployMission: null mission provided. Trace %1", diag_stacktrace] call BIS_fnc_error; false;};

// Setup and resume from mission settings
private _mission = getGroupMission(_group);
private _travelNodes = getDeployMissionNodes(_mission) ;

private _pathIdx = -1;
private _path = [] ;
//diag_log format["DoDeploy: Running new mission on group %1", getGroupID(_group)] ;
_idx = getDeployMissionNodeIdx(_mission) + 1; // Move to next node index

[_group, true, true, (_travelNodes select (count _travelNodes - 1))] call Sim_fnc_fireMission ;

if (([_group] call Sim_fnc_isLastMissionNode)) then {
	_exit = true ; // not enough nodes to move, already at destination
};

private _now = dateToNumber date ; 

while {!_exit} do {
	// Handle all timers using in world time. If any time change is made then this will impact missions, but hopefully in a more realistic way
	_now = dateToNumber date ; 
	
	_mission = getGroupMission(_group) ;
	//diag_log format["DoDeploy: Running mission %1", _mission] ;
	// If the mission has changed in any way then exit the mission now 
	if (count _mission == 0 || getMissionID(_mission) != "Deploy") exitWith {_exit = true};
	
	if (!([_group] call Sim_fnc_isLastMissionNode)) then {
		private _node = _graph get (_travelNodes select _idx);
		private _owner = _node get "owner" ;
		
		// Check destination for enemy capture
		if (([getGroupSide(_group), _owner] call BIS_fnc_sideIsEnemy) && !_abort) then {
			//diag_log format ["DoDeploy: aborting as travel destination node %1 is enemy for group %2", _travelNodes select _idx, getGroupID(_group)] ;
			// cancel mission and re-evaluate
			// Work back to last node
			_abort = true ;
			[_group, _graph] call Sim_fnc_abortMission ;
			_travelNodes = getDeployMissionNodes(_mission) ;
			_pathIdx = -1 ; // reset index
			_idx = 1 ;
		}else{
			// Check for first run and setup the path index to follow
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
				if (_pathIdx == 0 && _idx > 0) then {
					//diag_log format ["DoDeploy: Leaving node index %1 for node %2", _idx - 1, _travelNodes select _idx];
					[_group, (_travelNodes select (_idx - 1)), false] spawn Sim_fnc_fireNodeGroupChange ; // leaving node
				};
				_pathIdx = _pathIdx + 1; // Increment path index to move
				if (_pathIdx < (count _path)) then { // Helper func - is at end of path?
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
		
		_exit = true ;
	};
	[_group] spawn Sim_fnc_fireGroupMoveChange ;

	sleep 1 ; // avoid overloading the scheduler
};
[_group] spawn Sim_fnc_fireGroupMoveChange ;
setDeployMissionTimestamp(_mission, _now) ;

if (!_abort) then {
	waitUntil{sleep 10; _now = dateToNumber date ; _now > (_finalTimeout + getDeployMissionTimestamp(_mission));};
};

[_group, false, !_abort, (_travelNodes select getDeployMissionNodeIdx(_mission))] spawn Sim_fnc_fireMission ;

[_group] call Sim_fnc_removeMission ; // Clear the mission from group

true ;
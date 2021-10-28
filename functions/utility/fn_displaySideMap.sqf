/*
	Author: HangoverIt

	Description:
	Draw representation of the side graph on the game map (note that lines do not work unless map display available at time of execution)

	Parameter(s):
		0 (Mandatory): Side to display
		1 (Mandatory): Populated location graph

	Returns:
	BOOL
*/
#include "..\graph\graph.hpp"
params["_side", "_graph"] ;

private _sideGraph = [_side] call Sim_fnc_getSideGraph ;
if (isNil "_sideGraph") exitWith {["Invalid side given"] call BIS_fnc_error; false;};

{
	_key = _x ;
	_sideNode = _sideGraph get _key ;
	_node = _y ;

	_position = _node get "position"; // key location value
	_nodeSide = _node get "owner" ;
	_score = _sideNode get "score" ;

	_markerName = format["sidemkr%1", _key];
	_mkr = createMarkerLocal [_markerName, _position] ;
	_markerName setMarkerTypeLocal "loc_Ruin" ;
	_mkrColour = switch (_nodeSide) do {
		case east: {"colorOPFOR"};
		case resistance: {"colorIndependent"};
		case west: {"colorBLUFOR"};
		default {"colorCivilian"} ;
	};
	_markerName setMarkerColor _mkrColour ;
	_markerName setMarkerText format["%1", _score]; // get the distance from path record
  
}forEach _graph;

true;
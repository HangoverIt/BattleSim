/*
	Author: HangoverIt

	Description:
	Draw representation of the location graph on the game map (note that lines do not work unless map display available at time of execution)

	Parameter(s):
		0 (Mandatory): Populated location graph

	Returns:
	BOOL
*/
#include "..\graph\graph.hpp"
params["_graph"] ;
{
  _key = _x ;
  _v1 = _y get "position"; // key location value
  _paths = _y get "paths" ;
  {
    _destination = _graph get _x ; // lookup destination in the graph
	_v2 = _destination get "position" ; // path destination
	_diff = _v1 vectorDiff _v2 ;
	_diff = _diff vectorMultiply 0.5 ;
	_labelpos = _v2 vectorAdd _diff ;
    (findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["Draw",format["
	(_this select 0) drawLine [
		%1,
		%2,
		[0,1,0,1]
	  ];
    ",_v1,_v2]];
	diag_log format["From %1 to %2", _key, _x] ;
	_mkr = createMarkerLocal [format["distancemkr%1%2", _key, _x], _labelpos] ;
    _mkr setMarkerTypeLocal "hd_dot" ;
    _mkr setMarkerColor "ColorGreen" ;
	_mkr setMarkerText format["%1", getPathDistance(_y)]; // get the distance from path record
  }forEach _paths ; // foreach paths from node location
  
}forEach _graph;

true;
/*
	Author: HangoverIt

	Description:
	Draw representation of the location graph on the game map (note that lines do not work unless map display available at time of execution)

	Parameter(s):
		0 (Mandatory): Populated location graph

	Returns:
	BOOL
*/
params["_graph"] ;
{
  _key = _x ;
  {
    _v1 = _key select 1; // key location value
	_v2 = _x select 1;  // key location value
	_diff = _v1 vectorDiff _v2 ;
	_diff = _diff vectorMultiply 0.5 ;
	_labelpos = _v2 vectorAdd _diff ;
    (findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["Draw",format["
	(_this select 0) drawLine [
		%1,
		%2,
		[0,1,0,1]
	  ];
    ",_key select 1,_x select 1]];
	//diag_log format["From %1 to %2", _key, _x] ;
	_mkr = createMarkerLocal [format["distancemkr%1%2", _key select 0, _x select 0], _labelpos] ;
    _mkr setMarkerTypeLocal "hd_dot" ;
    _mkr setMarkerColor "ColorGreen" ;
	_mkr setMarkerText format["%1", _y select 0]; // first data item for location is distance
  }forEach _y ;
  
}forEach _graph;

true;